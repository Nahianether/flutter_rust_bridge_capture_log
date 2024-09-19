use screenshots::Screen;
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
