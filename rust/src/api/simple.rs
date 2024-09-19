use screenshots::Screen;
// #[cfg(target_os = "windows")]
use winapi::um::winevt::{
    EvtQuery, EvtQueryReverseDirection, EvtRender, EvtRenderEventXml,
    EVT_HANDLE, EVT_QUERY_FLAGS,
};
use winapi::um::winnt::LPCWSTR;
use std::ptr::null_mut;

use std::ffi::OsStr;
use std::os::windows::ffi::OsStrExt;


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

// #[cfg(target_os = "windows")]
#[flutter_rust_bridge::frb(sync)]
pub fn collect_windows_logs() -> String {
    let query: Vec<u16> = OsStr::new("Application").encode_wide().chain(Some(0)).collect();
    let flags = EVT_QUERY_FLAGS(1); // Use appropriate flag here
    let h_results: EVT_HANDLE;

    unsafe {
        h_results = EvtQuery(null_mut(), query.as_ptr(), null_mut(), flags);

        if h_results.is_null() {
            return "Failed to query event logs.".to_string();
        }

        let mut buffer = vec![0u8; 1024];
        let mut buffer_used = 0;
        let mut property_count = 0;
        let mut logs = String::new();

        while EvtNext(h_results, 1, &mut buffer as *mut _ as *mut EVT_HANDLE, 0, 0, &mut property_count) != 0 {
            EvtRender(null_mut(), buffer[0] as EVT_HANDLE, EvtRenderEventXml, buffer.len() as u32, buffer.as_mut_ptr() as *mut _, &mut buffer_used, &mut property_count);
            logs.push_str(&String::from_utf8_lossy(&buffer[..buffer_used as usize]));
            logs.push('\n');
        }

        logs
    }
}