const std = @import("std");

<#list helper.listFiles("src") as dirname>
pub const ${dirname} = struct {
  <#list helper.listFiles("src/" + dirname) as filename>
  pub const ${zig.nameType(filename)} = @import("${dirname}/${filename}.zig").${zig.nameType(filename)};
  </#list>
};
</#list>