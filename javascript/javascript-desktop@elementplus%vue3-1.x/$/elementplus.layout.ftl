<#--
 ### 文本输入框
 -->
<#macro print_layout_input_text attr indent>
  <#assign obj = attr.getParent()>
${""?left_pad(indent)}<el-input v-model="${js.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)}">
<#if attr.getLabelledOptions("name")["unit"]??>  
${""?left_pad(indent)}  <template #append>${attr.getLabelledOptions("name")["unit"]}</template>
</#if>      
${""?left_pad(indent)}</el-input>
</#macro> 

<#--
 ### 【下拉单选】输入框
 -->
<#macro print_layout_input_select attr indent>
  <#assign obj = attr.getParent()>
  <#if modelbase.is_attribute_enum(attr)>
${""?left_pad(indent)}<el-select clearable
${""?left_pad(indent)}    v-model="${js.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)}" 
${""?left_pad(indent)}    placeholder="请选择...">
${""?left_pad(indent)}  <el-option
${""?left_pad(indent)}      v-for="item in sdk.arrayOf${js.nameType(obj.name)}${js.nameType(modelbase.get_attribute_sql_name(attr))}"
${""?left_pad(indent)}      :key="item.value"
${""?left_pad(indent)}      :label="item.text"
${""?left_pad(indent)}      :value="item.value" />
${""?left_pad(indent)}</el-select>  
  <#elseif attr.type.custom>
${""?left_pad(indent)}<el-select clearable
${""?left_pad(indent)}    v-model="${js.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)}" 
${""?left_pad(indent)}    placeholder="请选择...">
${""?left_pad(indent)}  <el-option
${""?left_pad(indent)}      v-for="item in dataOf${modelbase.get_attribute_sql_name(attr)}"
${""?left_pad(indent)}      :key="item.value"
${""?left_pad(indent)}      :label="item.label"
${""?left_pad(indent)}      :value="item.value" />
${""?left_pad(indent)}</el-select>
  </#if>
</#macro>

<#--
 ### 【复选】输入框
 -->
<#macro print_layout_input_check attr indent>
  <#assign obj = attr.getParent()>
  <#assign pairs = typebase.enumtype(attr.constraint.domainType.name)>
${""?left_pad(indent)}<el-checkbox-group v-model="${js.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)}">
  <#list pairs as pair>
${""?left_pad(indent)}  <el-checkbox value="${pair.key}">${pair.value}</el-checkbox>
  </#list>
${""?left_pad(indent)}</el-checkbox-group>
</#macro>

<#--
 ### 【复选】输入框
 -->
<#macro print_layout_input_radio attr indent>
  <#assign obj = attr.getParent()>
  <#assign pairs = typebase.enumtype(attr.constraint.domainType.name)>
${""?left_pad(indent)}<el-radio-group v-model="${js.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)}">
  <#list pairs as pair>
${""?left_pad(indent)}  <el-radio value="${pair.key}">${pair.value}</el-radio>
  </#list>
${""?left_pad(indent)}</el-radio-group>
</#macro>

<#--
 ### 【日期】输入框
 -->
<#macro print_layout_input_date attr indent>
  <#assign obj = attr.getParent()>
${""?left_pad(indent)}<el-date-picker v-model="${js.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)}" type="date" placeholder="请选择..." style="width: 100%" />
</#macro>

<#--
 ### 【开关】输入框
 -->
<#macro print_layout_input_switch attr indent>
  <#assign obj = attr.getParent()>
${""?left_pad(indent)}<el-switch
${""?left_pad(indent)}    v-model="${js.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)}"
${""?left_pad(indent)}    style="--el-switch-on-color: #13ce66; --el-switch-off-color: #ff4949"
${""?left_pad(indent)}</el-switch>
</#macro>

<#--
 ### 【评分】输入框
 -->
<#macro print_layout_input_rate attr indent>
  <#assign obj = attr.getParent()>
${""?left_pad(indent)}<el-rate v-model="${js.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)}" :colors="colors" />
</#macro>

<#--
 ### 【滑动】输入框
 -->
<#macro print_layout_input_slider attr indent>
  <#assign obj = attr.getParent()>
${""?left_pad(indent)}<el-slider v-model="${js.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)}" :colors="colors" />
</#macro>

<#--
 ### 【日期】输入框
 -->
<#macro print_layout_input_date attr indent>
  <#assign obj = attr.getParent()>
${""?left_pad(indent)}<el-date-picker
${""?left_pad(indent)}    v-model="${js.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)}"
${""?left_pad(indent)}    type="date"
${""?left_pad(indent)}    placeholder="请选择..."
${""?left_pad(indent)}    :disabled-date="disabledDate"
${""?left_pad(indent)}    :shortcuts="shortcuts"
${""?left_pad(indent)}    :size="size" />
</#macro>
<#--
 ### 【时间】输入框
 -->
<#macro print_layout_input_time attr indent>
  <#assign obj = attr.getParent()>
${""?left_pad(indent)}<el-time-picker arrow-control
${""?left_pad(indent)}    v-model="${js.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)}"
${""?left_pad(indent)}    placeholder="请选择..." />
</#macro>

<#--
 ### 多个选择输入框
 -->
<#macro print_layout_input_multiselect attr indent>
  <#assign obj = attr.getParent()>
${""?left_pad(indent)}<el-select multiple
${""?left_pad(indent)}    v-model="${js.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)}" 
${""?left_pad(indent)}    clearable placeholder="请选择...">
${""?left_pad(indent)}</el-select>
</#macro> 

<#--
 ### 单个头像输入框
 -->
<#macro print_layout_input_avatar attr indent>
${""?left_pad(indent)}<el-upload
${""?left_pad(indent)}    class="avatar-uploader"
${""?left_pad(indent)}    action="https://run.mocky.io/v3/9d059bf9-4660-45f2-925d-ce80ad6c4d15"
${""?left_pad(indent)}    :show-file-list="false"
${""?left_pad(indent)}    :on-success="handleAvatarSuccess"
${""?left_pad(indent)}    :before-upload="beforeAvatarUpload">
${""?left_pad(indent)}  <img v-if="imageUrl" :src="imageUrl" class="avatar" />
${""?left_pad(indent)}  <el-icon v-else class="avatar-uploader-icon"><Plus /></el-icon>
${""?left_pad(indent)}</el-upload>
</#macro> 

<#--
 ### 多个头像输入框
 -->
<#macro print_layout_input_avatars attr indent>
${""?left_pad(indent)}<!-- TODO: 实现多个头像输入 -->
</#macro>

<#--
 ### 单个图片输入框
 -->
<#macro print_layout_input_image attr indent>
  <#assign obj = attr.getParent()>
${""?left_pad(indent)}<el-image show-progress
${""?left_pad(indent)}    ref="ref${js.nameType(attr.name)}"
${""?left_pad(indent)}    style="width: 128px; height: 128px"
${""?left_pad(indent)}    :src="${js.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)}"
${""?left_pad(indent)}    :preview-src-list="${js.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)}"
${""?left_pad(indent)}    fit="cover"
${""?left_pad(indent)}/>
</#macro>

<#macro print_layout_input_files attr indent>
  <#assign obj = attr.getParent()>
${""?left_pad(indent)}<el-upload multiple
${""?left_pad(indent)}    v-model:file-list="${js.nameVariable(obj.name)}.${modelbase.get_attribute_sql_name(attr)}"
${""?left_pad(indent)}    class=""
${""?left_pad(indent)}    action=""
${""?left_pad(indent)}    :on-preview="doPreviewFrom${js.nameType(attr.name)}"
${""?left_pad(indent)}    :on-remove="doRemoveFrom${js.nameType(attr.name)}"
${""?left_pad(indent)}    :on-exceed="doExceedFor${js.nameType(attr.name)}">
${""?left_pad(indent)}  <el-button type="primary">上传文件</el-button>
${""?left_pad(indent)}  <template #tip>
${""?left_pad(indent)}    <div class="el-upload__tip">
${""?left_pad(indent)}      jpg/png files with a size less than 500KB.
${""?left_pad(indent)}    </div>
${""?left_pad(indent)}  </template>
${""?left_pad(indent)}</el-upload>
</#macro>

<#--
 ### 可编辑表单
 -->
<#macro print_layout_editable_form obj indent>
${""?left_pad(indent)}<el-form 
${""?left_pad(indent)}    :model="${js.nameVariable(obj.name)}" 
${""?left_pad(indent)}    :rules="rules${js.nameType(obj.name)}" 
${""?left_pad(indent)}    ref="refForm${js.nameType(obj.name)}" 
${""?left_pad(indent)}    label-width="auto" style="max-width: 600px;">
  <#list obj.attributes as attr>
    <#if modelbase.is_attribute_avatar(attr)>
${""?left_pad(indent)}<el-upload
${""?left_pad(indent)}    class="avatar-uploader"
${""?left_pad(indent)}    action="https://run.mocky.io/v3/9d059bf9-4660-45f2-925d-ce80ad6c4d15"
${""?left_pad(indent)}    :show-file-list="false"
${""?left_pad(indent)}    :on-success="handleAvatarSuccess"
${""?left_pad(indent)}    :before-upload="beforeAvatarUpload">
${""?left_pad(indent)}  <img v-if="imageUrl" :src="imageUrl" class="avatar" />
${""?left_pad(indent)}  <el-icon v-else class="avatar-uploader-icon"><Plus /></el-icon>
${""?left_pad(indent)}</el-upload>  
    </#if>
    <#if modelbase.is_attribute_cover(attr)>
${""?left_pad(indent)}<el-upload
${""?left_pad(indent)}    class="cover-uploader"
${""?left_pad(indent)}    action="https://run.mocky.io/v3/9d059bf9-4660-45f2-925d-ce80ad6c4d15"
${""?left_pad(indent)}    :show-file-list="false"
${""?left_pad(indent)}    :on-success="handleAvatarSuccess"
${""?left_pad(indent)}    :before-upload="beforeAvatarUpload">
${""?left_pad(indent)}  <img v-if="imageUrl" :src="imageUrl" class="cover" />
${""?left_pad(indent)}  <el-icon v-else class="cover-uploader-icon"><Plus /></el-icon>
${""?left_pad(indent)}</el-upload>
  </#if>
  </#list>
  <#list obj.attributes as attr>
    <#if attr.identifiable><#continue></#if>
    <#if modelbase.is_attribute_avatar(attr)><#continue></#if>
    <#if modelbase.is_attribute_system(attr)><#continue></#if>
${""?left_pad(indent)}  <el-form-item label="${modelbase.get_attribute_label(attr)}" 
${""?left_pad(indent)}      prop="${modelbase.get_attribute_sql_name(attr)}">    
    <#if attr.type.name == "date" || attr.type.name == "datetime">
<@print_layout_input_date attr=attr indent=indent+2 />
    <#elseif modelbase.is_attribute_enum(attr)>
<@print_layout_input_select attr=attr indent=indent+2 />
    <#else>
<@print_layout_input_text attr=attr indent=indent+2 />    
    </#if>
${""?left_pad(indent)}  </el-form-item>      
  </#list>
${""?left_pad(indent)}</el-form>
</#macro>   

<#--
 ### 迷你图
 -->
<#macro print_layout_sparkline obj indent>
${""?left_pad(indent)}<div ref="sparkline${js.nameType(obj.name)}" 
${""?left_pad(indent)}    style="width:180px;height:60px;">
${""?left_pad(indent)}</div>
</#macro> 

