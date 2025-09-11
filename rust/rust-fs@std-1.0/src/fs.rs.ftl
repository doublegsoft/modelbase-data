<#import "/$/modelbase.ftl" as modelbase>
<#if license??>
${rust.license(license)}
</#if>
use std::io;
use std::fs;
use std::path::Path;

/*
** 从文件读取文本。
*/
#[allow(dead_code)]
pub fn read_text_from_file(path: &str) -> Option<String> {
  match fs::read_to_string(path) {
    Ok(content) => {
      return Some(content);
    }
    Err(_) => {
      return Option::None;
    }
  }
}

/*
** 把文本写入文件。
*/
#[allow(dead_code)]
pub fn write_text_to_file(path: &str, content: String) {
  match fs::write(path, content) {
    Ok(_) => {
      println!("Data has been written to the file.");
    }
    Err(err) => {
      eprintln!("Error writing to file: {}", err);
    }
  }
}

/*
** 遍历文件路径。
*/
#[allow(dead_code)]
pub fn recurse_directory(dir: &Path, cb:fn(&Path)) -> io::Result<()> {
  if dir.is_dir() {
    for entry in fs::read_dir(dir).expect("the directory exists") {
      let path = entry?.path();
      if path.is_dir() {
        let _ = recurse_directory(&path, cb);
      } else {
        cb(dir);
      }
    }
  }
  Ok(())
}
