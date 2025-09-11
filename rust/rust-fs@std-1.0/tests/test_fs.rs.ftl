<#import "/$/modelbase.ftl" as modelbase>
<#if license??>
${rust.license(license)}
</#if>
use ${namespace}::fs::*;
use std::path::Path;

/*
** 测试读取和写入文件。
*/
#[test]
fn test_read_text_from_file() {
  let content: Option<String> = read_text_from_file("/Users/christian/package.json");
  match content {
    Some(value) => {
      write_text_to_file("/Users/christian/package2.json", value);
    }
    None => {
      assert!(false);
    }
  }
}

fn recurse_directory_callback(path: &Path) {
  println!("{}", path.display());
}

/*
** 测试遍历文件夹。
*/
#[test]
fn test_recurse_directory() {
  let path = Path::new("/Users/christian/Downloads");
  let _ = recurse_directory(path, recurse_directory_callback);
}
 