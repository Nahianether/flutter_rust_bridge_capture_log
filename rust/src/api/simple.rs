use screenshots::Screen;
use sysinfo::{ProcessExt, SystemExt as _};
// #[cfg(target_os = "windows")]
use rdev::{listen, EventType};
use std::{
    sync::{Arc, Mutex},
    thread,
    time::Duration,
};
use notify::{recommended_watcher, Event, RecursiveMode, Watcher};
use std::sync::mpsc::channel;
use std::path::Path;
// use leptess::LepTess;
// use regex::Regex;


#[flutter_rust_bridge::frb(sync)] // Synchronous mode for simplicity of the demo
pub fn greet(name: String) -> String {
    format!("Hello, {name}!")
}

#[flutter_rust_bridge::frb(init)]
pub fn init_app() {
    // Default utilities - feel free to customize
    flutter_rust_bridge::setup_default_user_utils();
}

#[flutter_rust_bridge::frb(sync)]
pub fn take_s(path: String) {
    println!("Message: {}", path);
    // format!("path, {path}!");

    let screens = Screen::all().unwrap();

    let scr = screens.first().unwrap();
    let image = scr.capture().unwrap();
    image.save(path.clone()).unwrap();
    println!("Screenshot saved to {path}");
    // "done".to_string()
}

// #[flutter_rust_bridge::frb(sync)]
// pub fn take_url_from_image(){
//         let image_path = "D:/piic/screenshots.png";
    
//     let mut lt = LepTess::new(None, "eng").expect("Failed to initialize Tesseract");
//     lt.set_image(image_path).expect("Failed to set image");
//     let text = lt.get_utf8_text().expect("Failed to extract text");

//     let domain_regex = Regex::new(r"(https?://)?([a-zA-Z0-9-]+\.[a-zA-Z]{2,})").unwrap();

//     let mut domains_found = Vec::new();
//     for capture in domain_regex.captures_iter(&text) {
//     if let Some(domain) = capture.get(2) {
//         domains_found.push(domain.as_str().to_string());
//     }
// }

// if !domains_found.is_empty() {
//     println!("Domains found in the image: {:?}", domains_found);
// } else {
//     println!("No domains found in the image.");
// }
// }

// mouse keyboard detection old
// #[flutter_rust_bridge::frb(sync)]
// pub fn listen_to_keyboards_main() {
//     if let Err(error) = listen(|event| {
//         match event.event_type {
//             EventType::KeyPress(key) => {
//                 println!("Key pressed: {:?}", key);
//             }
//             EventType::MouseMove { x, y } => {
//                 println!("Mouse moved to: ({}, {})", x, y);
//             }
//             _ => (),
//         }
//     }) {
//         println!("Error: {:?}", error)
//     }
// }

#[flutter_rust_bridge::frb(sync)]
pub fn listen_to_keyboards_main() {
    let event_triggered = Arc::new(Mutex::new(false));
    let event_message = Arc::new(Mutex::new(String::new()));

    // Listen to mouse and keyboard events in a separate thread
    let event_triggered_clone = Arc::clone(&event_triggered);
    let event_message_clone = Arc::clone(&event_message);
    thread::spawn(move || {
        if let Err(error) = listen(move |event| {
            let mut event_detected = event_triggered_clone.lock().unwrap();
            *event_detected = true; // Event occurred, set the flag

            let mut message = event_message_clone.lock().unwrap();
            match event.event_type {
                EventType::KeyPress(key) => {
                    *message = format!("Key pressed: {:?}", key);
                }
                EventType::MouseMove { x, y } => {
                    *message = format!("Mouse moved to: ({}, {})", x, y);
                }
                _ => (),
            }
        }) {
            println!("Error: {:?}", error);
        }
    });

    // Timer to check for idle state every 2 minutes
    loop {
        thread::sleep(Duration::from_secs(10)); // 2-minute interval

        let event_detected = event_triggered.lock().unwrap();
        let message = event_message.lock().unwrap();
        if *event_detected {
            println!("{}", *message); // Print the last detected event
            // *event_detected = false; // Reset the flag
        } else {
            println!("System is idle.");
        }
    }
}

// this function will take multiple display screenshot
// pub fn take_s(path: String) {
//     println!("Message: {}", path);

//     let screens = Screen::all().unwrap();

//     for (index, screen) in screens.iter().enumerate() {
//         let image = screen.capture().unwrap();
//         let screen_path = format!("{}_screen_{}.png", path, index);
//         image.save(screen_path.clone()).unwrap();
//         println!("Screenshot saved to {}", screen_path);
//     }
// }

// -----------------------------------------------------------------------------------------------------------------------

// #[flutter_rust_bridge::frb(sync)]
// pub fn get_chrome_history(path: &String) -> Vec<String> {
//     let query =
//         "SELECT url, title, last_visit_time FROM urls ORDER BY last_visit_time DESC LIMIT 10";
//     let conn = rusqlite::Connection::open(path).unwrap();
//     let mut stmt = conn.prepare(query).unwrap();

//     let rows = stmt.query_map([], |row| {
//         Ok(format!(
//             "{:?}: {:?} ({:?})",
//             row.get::<usize, String>(0),
//             row.get::<usize, String>(1),
//             row.get::<usize, i64>(2)
//         ))
//     });

//     let mut history = Vec::new();

//     for row in rows.unwrap() {
//         if let Ok(row) = row {
//             println!("{}", row);
//             history.push(row);
//         }
//     }

//     history
// }


#[flutter_rust_bridge::frb(sync)]
pub fn get_running_processes() -> Vec<String> {
    let mut system = sysinfo::System::new_all();
    system.refresh_all();

    let mut processes = Vec::new();
    for (pid, process) in system.processes() {
        processes.push(format!(
            "{}: {:?} ({})",
            pid,
            process.name(),
            process.cpu_usage()
        ));
        println!("{}: {:?} ({})", pid, process.name(), process.cpu_usage());
    }

    processes
}

use anyhow::Result;

#[flutter_rust_bridge::frb(sync)]
pub fn file_system_monitor() -> Result<()> {
    // Create a new thread for the file system watcher
    thread::spawn(|| {
        // Set up channel for communication
        let (tx, rx) = channel();

        // Set up the watcher
        let mut watcher = recommended_watcher(tx).expect("Failed to create watcher");
        watcher
            .watch(Path::new("D:/"), RecursiveMode::Recursive)
            .expect("Failed to watch path");

        // Handle file events in a loop
        loop {
            match rx.recv() {
                Ok(event) => match event {
                    Ok(Event { kind, paths, .. }) => {
                        for path in paths {
                            match kind {
                                notify::event::EventKind::Create(_) => {
                                    println!("File created: {:?}", path)
                                }
                                notify::event::EventKind::Modify(_) => {
                                    println!("File modified: {:?}", path)
                                }
                                notify::event::EventKind::Remove(_) => {
                                    println!("File deleted: {:?}", path)
                                }
                                _ => println!("Other event: {:?}", path),
                            }
                        }
                    }
                    Err(e) => println!("Watch error: {:?}", e),
                },
                Err(e) => println!("Channel error: {:?}", e),
            }
        }
    });

    Ok(())
}