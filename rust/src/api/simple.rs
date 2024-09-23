use screenshots::Screen;
use sysinfo::{ProcessExt, SystemExt as _};
// #[cfg(target_os = "windows")]



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

#[flutter_rust_bridge::frb(sync)]
pub fn get_chrome_history(path: &String) -> Vec<String> {
    let query =
        "SELECT url, title, last_visit_time FROM urls ORDER BY last_visit_time DESC LIMIT 10";
    let conn = rusqlite::Connection::open(path).unwrap();
    let mut stmt = conn.prepare(query).unwrap();

    let rows = stmt.query_map([], |row| {
        Ok(format!(
            "{:?}: {:?} ({:?})",
            row.get::<usize, String>(0),
            row.get::<usize, String>(1),
            row.get::<usize, i64>(2)
        ))
    });

    let mut history = Vec::new();

    for row in rows.unwrap() {
        if let Ok(row) = row {
            println!("{}", row);
            history.push(row);
        }
    }

    history
}


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