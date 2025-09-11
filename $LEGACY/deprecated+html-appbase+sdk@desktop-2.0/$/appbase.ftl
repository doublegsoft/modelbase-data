<#macro html_item_widget indent type model>
  <#if type == 'single_line'>
<@html_item_single_line indent=indent model=model />
  <#elseif type == 'two_line'>
<@html_item_two_line indent=indent model=model />
  <#elseif type == 'two_line_float'>
<@html_item_two_line_float indent=indent model=model />
  <#elseif type == 'image_two_line'>
<@html_item_image_two_line indent=indent model=model />
  <#elseif type == 'image_three_line'>
<@html_item_image_three_line indent=indent model=model />
  <#elseif type == 'image_two_line_float'>
<@html_item_image_two_line_float indent=indent model=model />
  <#elseif type == 'duration_progress'>
<@html_item_duration_progress indent=indent model=model />
  <#elseif type == 'comparison_progress'>
<@html_item_comparison_progress indent=indent model=model />
  <#elseif type == 'circular_progress'>
<@html_item_circular_progress indent=indent model=model />
  <#elseif type == 'tag_head'>
<@html_item_tag_head indent=indent model=model />
  <#elseif type == 'tag_tail'>
<@html_item_tag_tail indent=indent model=model />
  <#elseif type == 'switch'>
<@html_item_switch indent=indent model=model />
  <#elseif type == 'tristate'>
<@html_item_tristate indent=indent model=model />
  <#elseif type == 'person'>
<@html_item_person indent=indent model=model />
  </#if>
</#macro>

<#--
 ### ------------------
 ### | title          |
 ### ------------------
 -->
<#macro html_item_single_line indent model>
${''?left_pad(indent)}<strong>${r'${row.'}${model.primary!'primary'}${r'}'}</strong>
</#macro>

<#--
 ### ------------------
 ### | primary        |
 ### | secondary      |
 ### ------------------
 -->

<#macro html_item_two_line indent model>
${''?left_pad(indent)}<div class="pl-2" style="border-left: 4px solid rgb(229, 83, 83);">
${''?left_pad(indent)}  <div>${r'${row.'}${model.primary!'primary'}${r'}'}</div>
${''?left_pad(indent)}  <div class="small text-muted">${r'${row.'}${model.secondary!'secondary'}${r'}'}</div>
${''?left_pad(indent)}</div>
</#macro>

<#--
 ### -------------------------
 ### |  /\  | primary        |
 ### |  \/  | secondary      |
 ### -------------------------
 -->
<#macro html_item_image_two_line indent model>
${''?left_pad(indent)}<div class="d-flex align-items-center">
${''?left_pad(indent)}  <div class="bg-gradient-primary">
${''?left_pad(indent)}    <img src="${r'${row.'}${model.image!'image'}${r'}'}" style="width:56px; height: 56px">
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}  <div>
${''?left_pad(indent)}    <div class="text-value text-primary font-16">${r'${row.'}${model.primary!'primary'}${r'}'}</div>
${''?left_pad(indent)}    <div class="text-muted font-weight-bold small">${r'${row.'}${model.secondary!'secondary'}${r'}'}</div>
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}</div>
</#macro>

<#-- Tertiary. Then quaternary (4), quinary (5), senary (6), septenary (7), octonary (8), nonary (9), and denary (10) -->
<#--
 ### -------------------------
 ### |  /\  | primary        |
 ### |  []  | secondary      |
 ### |  \/  | tertiary       |
 ### -------------------------
 -->
<#macro html_item_image_three_line indent model>
${''?left_pad(indent)}<div class="d-flex align-items-center">
${''?left_pad(indent)}  <div class="bg-gradient-primary">
${''?left_pad(indent)}    <img src="${r'${row.'}${model.image!'image'}${r'}'}" style="width:96px; height: 96px">
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}  <div>
${''?left_pad(indent)}    <div class="text-value text-primary font-16">${r'${row.'}${model.primary!'primary'}${r'}'}</div>
${''?left_pad(indent)}    <div class="text-muted font-weight-bold small">${r'${row.'}${model.secondary!'secondary'}${r'}'}</div>
${''?left_pad(indent)}    <div class="text-muted">${r'${row.'}${model.tertiary!'tertiary'}${r'}'}</div>
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}</div>
</#macro>

<#--
 ### ----------------------------
 ### |  /\  | primary      | /\ |
 ### |  \/  | secondary    | \/ |
 ### ----------------------------
 -->
<#macro html_item_image_two_line_float indent model>
${''?left_pad(indent)}<div class="d-flex align-items-center">
${''?left_pad(indent)}  <div class="bg-gradient-primary">
${''?left_pad(indent)}    <img src="${r'${row.'}${model.image!'image'}${r'}'}" style="width:56px; height: 56px">
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}  <div>
${''?left_pad(indent)}    <div class="text-value text-primary font-16">${r'${row.'}${model.primary!'primary'}${r'}'}</div>
${''?left_pad(indent)}    <div class="text-muted font-weight-bold small">${r'${row.'}${model.secondary!'secondary'}${r'}'}</div>
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}  <div class="float-right position-relative" style="top: 8px; height: 26px;">
${''?left_pad(indent)}    <i class="fas fa-todo"></i>
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}</div>
</#macro>

<#--
 ### ---------------------
 ### | primary      | /\ |
 ### | secondary    | \/ |
 ### ---------------------
 -->
<#macro html_item_two_line_float model>
${''?left_pad(indent)}<div class="d-flex justify-content-between pl-2 full-width" style="border-left: 4px solid rgb(69, 161, 100);">
${''?left_pad(indent)}  <div>
${''?left_pad(indent)}    <div>${r'${row.'}${model.primary!'primary'}${r'}'}</div>
${''?left_pad(indent)}    <div class="small text-muted">
${''?left_pad(indent)}      <span class="text-success">${r'${row.'}${model.secondary!'secondary'}${r'}'}</span>
${''?left_pad(indent)}    </div>
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}  <div class="float-right position-relative" style="top: 8px; height: 26px;">
${''?left_pad(indent)}    <i class="fas fa-todo"></i>
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}</div>
</#macro>

<#--
 ### --------------------------
 ### | /\ | /\ | /\ | /\ | /\ |
 ### | \/ | \/ | \/ | \/ | \/ |
 ### --------------------------
 -->
<#macro html_item_images indent model>
${''?left_pad(indent)}<div class="row m-auto" style="justify-content: center;">
${''?left_pad(indent)}</div>
</#macro>

<#macro html_item_image indent model>
${''?left_pad(indent)}<div class="avatar avatar-36 tooltip-avatar">
${''?left_pad(indent)}  <img src="${r'${row.'}${model.image!'image'}${r'}'}">
${''?left_pad(indent)}  <span class="tooltip-text">${r'${row.'}${model.primary!'primary'}${r'}'}</span>
${''?left_pad(indent)}</div>
</#macro>

<#--
 ### --------------------------
 ### | 80%        start - end |
 ### | ==================     |
 ### --------------------------
 -->
<#macro html_item_duration_progress indent model>
${''?left_pad(indent)}<div>
${''?left_pad(indent)}  <div class="clearfix">
${''?left_pad(indent)}    <div class="float-left">
${''?left_pad(indent)}      <strong>${r'${row.'}${model.percentage!'percentage'}${r'}'}%</strong>
${''?left_pad(indent)}    </div>
${''?left_pad(indent)}    <div class="float-right">
${''?left_pad(indent)}      <small class="text-muted">${r'${row.'}${model.startTime!'startTime'}${r'}'} - ${r'${row.'}${model.endTime!'endTime'}${r'}'}</small>
${''?left_pad(indent)}    </div>
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}  <div class="progress progress-xs">
${''?left_pad(indent)}    <div class="progress-bar bg-${r'${row.'}${model.status!'status'}${r'}'}" role="progressbar" style="width: ${r'${row.'}${model.percentage!'percentage'}${r'}'}%" aria-valuenow="${r'${row.'}${model.percentage!'percentage'}${r'}'}" aria-valuemin="0" aria-valuemax="100"></div> 
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}</div>
</#macro>

<#--
 ### --------------------------
 ### | primary            80% |
 ### | ==================     |
 ### --------------------------
 -->
<#macro html_item_theme_progress indent model>
${''?left_pad(indent)}<div class="progress-group">
${''?left_pad(indent)}  <div class="progress-group-header">
${''?left_pad(indent)}    <svg class="c-icon progress-group-icon">
${''?left_pad(indent)}      <use xlink:href="vendors/@coreui/icons/svg/free.svg#cil-user"></use>
${''?left_pad(indent)}    </svg>
${''?left_pad(indent)}    <div>${r'${row.'}${model.primary!'primary'}${r'}'}</div>
${''?left_pad(indent)}    <div class="mfs-auto font-weight-bold">${r'${row.'}${model.percentage!'percentage'}${r'}'}%</div>
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}  <div class="progress-group-bars">
${''?left_pad(indent)}    <div class="progress progress-xs">
${''?left_pad(indent)}      <div class="progress-bar bg-warning" role="progressbar" style="width: ${r'${row.'}${model.percentage!'percentage'}${r'}'}%" aria-valuenow="${r'${row.'}${model.percentage!'percentage'}${r'}'}" aria-valuemin="0" aria-valuemax="100"></div>
${''?left_pad(indent)}    </div>
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}</div>
</#macro>

<#--
 ### --------------------------
 ### | primary ============== |
 ### |         =========      |
 ### --------------------------
 -->
<#macro html_item_comparison_progress indent model>
${''?left_pad(indent)}<div class="progress-group mb-4">
${''?left_pad(indent)}  <div class="progress-group-prepend">
${''?left_pad(indent)}    <span class="progress-group-text">${r'${row.'}${model.primary!'primary'}${r'}'}</span>
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}  <div class="progress-group-bars">
${''?left_pad(indent)}    <div class="progress progress-xs">
${''?left_pad(indent)}      <div class="progress-bar bg-info" role="progressbar" style="width: ${r'${row.'}${model.percentage!'percentage'}${r'}'}%" aria-valuenow="${r'${row.'}${model.percentage!'percentage'}${r'}'}" aria-valuemin="0" aria-valuemax="100"></div>
${''?left_pad(indent)}    </div>
${''?left_pad(indent)}    <div class="progress progress-xs">
${''?left_pad(indent)}      <div class="progress-bar bg-danger" role="progressbar" style="width: ${r'${row.'}${model.percentage!'percentage'}${r'}'}%" aria-valuenow="${r'${row.'}${model.percentage!'percentage'}${r'}'}" aria-valuemin="0" aria-valuemax="100"></div>
${''?left_pad(indent)}    </div>
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}</div>
</#macro>

<#macro html_item_circular_progress>
${''?left_pad(indent)}<div class="progress-circle over50 p${r'${row.'}${model.percentage!'percentage'}${r'}'}">
${''?left_pad(indent)}  <span>${r'${row.'}${model.percentage!'percentage'}${r'}'}%</span>
${''?left_pad(indent)}  <div class="left-half-clipper">
${''?left_pad(indent)}    <div class="first50-bar"></div>
${''?left_pad(indent)}    <div class="value-bar"></div>
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}</div>
</#macro>

<#--
 ### ----------------------------
 ### | [] | primary | secondary |
 ### ----------------------------
 -->
<#macro html_item_person indent model>
${''?left_pad(indent)}<div class="ui yellow image label bg-info text-white">
${''?left_pad(indent)}  <img src="${r'${row.'}${model.image!'image'}${r'}'}" height="32">
${''?left_pad(indent)}  <span>${r'${row.'}${model.primary!'primary'}${r'}'}</span>
${''?left_pad(indent)}  <p class="detail">${r'${row.'}${model.secondary!'secondary'}${r'}'}</p>
${''?left_pad(indent)}</div>
</#macro>

<#--
 ### ----------
 ### | |----\ |
 ### | |----/ |
 ### ----------
 -->
<#macro html_item_tag_tail indent model>
${''?left_pad(indent)}<div class="font-13 m-auto tag-success">
${''?left_pad(indent)}  <span>${r'${row.'}${model.primary!'primary'}${r'}'}</span>
${''?left_pad(indent)}  <div class="tag-success-after"></div>
${''?left_pad(indent)}</div>
</#macro>

<#--
 ### ----------
 ### | /----| |
 ### | \----| |
 ### ----------
 -->
 <#macro html_item_tag_head indent model>
${''?left_pad(indent)}<a class="ui tag label bg-danger text-white ml-5">${r'${row.'}${model.primary!'primary'}${r'}'}</a>
</#macro>

<#--
 ### ---------------------------
 ### |  primary  |  secondary  |
 ### ---------------------------
 -->
<#macro html_item_switch indent model>
${''?left_pad(indent)}<div class="text-switch">
${''?left_pad(indent)}  <label class="mb-0" data-switch=".checked">
${''?left_pad(indent)}    <input name="text-switch" type="radio" style="display: none">${r'${row.'}${model.primary!'primary'}${r'}'}
${''?left_pad(indent)}  </label>
${''?left_pad(indent)}  <label class="mb-0 checked" data-switch=".checked">
${''?left_pad(indent)}    <input name="text-switch" type="radio" style="display: none">${r'${row.'}${model.secondary!'secondary'}${r'}'}
${''?left_pad(indent)}  </label>
${''?left_pad(indent)}</div>
</#macro>

<#--
 ### ----------------------------------------
 ### |  primary  |  secondary  |  tertiary  |
 ### ----------------------------------------
 -->
<#macro html_item_tristate indent model>
${''?left_pad(indent)}<div class="text-multi-switch">
${''?left_pad(indent)}  <label class="mb-0 checked" style="width: 33.3%" data-switch=".checked">
${''?left_pad(indent)}    <input type="radio" style="display: none;">${r'${row.'}${model.primary!'primary'}${r'}'}
${''?left_pad(indent)}  </label>
${''?left_pad(indent)}  <label class="mb-0" style="width: 33.3%" data-switch=".checked">
${''?left_pad(indent)}    <input type="radio" style="display: none;">${r'${row.'}${model.secondary!'secondary'}${r'}'}
${''?left_pad(indent)}  </label>
${''?left_pad(indent)}  <label class="mb-0" style="width: 33.4%" data-switch=".checked">
${''?left_pad(indent)}    <input type="radio" style="display: none;">${r'${row.'}${model.tertiary!'tertiary'}${r'}'}
${''?left_pad(indent)}  </label>
${''?left_pad(indent)}</div>
</#macro>