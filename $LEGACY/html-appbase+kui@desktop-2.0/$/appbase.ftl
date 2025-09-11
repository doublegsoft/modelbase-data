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

<#------------------------------------------------------------------------------
 ###
 ### ITEM
 ###
 ------------------------------------------------------------------------------>

<#--
 ### ------------------
 ### | primary        |
 ### ------------------
 -->
<#macro html_item_single_line indent model>
${''?left_pad(indent)}<div class="item list-view-item">
${''?left_pad(indent)}  <div class="header">{{{primary}}}</div>
${''?left_pad(indent)}</div>
</#macro>

<#--
 ### ------------------
 ### | primary        |
 ### | secondary      |
 ### ------------------
 -->
<#macro html_item_two_line indent model>
${''?left_pad(indent)}<div class="item list-view-item">
${''?left_pad(indent)}  <div class="header">{{{primary}}}</div>
${''?left_pad(indent)}  <div class="description">{{{secondary}}}</div>
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
${''?left_pad(indent)}    <img src="{{{image}}}" style="width:56px; height: 56px">
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}  <div>
${''?left_pad(indent)}    <div class="text-value text-primary font-16">{{{primary}}}</div>
${''?left_pad(indent)}    <div class="text-muted font-weight-bold small">{{{secondary}}}</div>
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
${''?left_pad(indent)}<div class="item list-view-item" style="height: 105px;">
${''?left_pad(indent)}  <div class="image circular">
${''?left_pad(indent)}    <img src="{{{image}}}" style="height: 80px;">
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}  <div class="content" style="padding-top: 6px!important;">
${''?left_pad(indent)}    <a class="header">{{{primary}}}</a>
${''?left_pad(indent)}    <div class="meta">
${''?left_pad(indent)}      <span>{{{secondary}}}</span>
${''?left_pad(indent)}    </div>
${''?left_pad(indent)}    <div class="description">
${''?left_pad(indent)}      <i class="fas fa-file-medical text-red" style="padding-right: 5px;"></i>{{{tertiary}}}
${''?left_pad(indent)}    </div>
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

</#macro>

<#--
 ### ---------------------
 ### | primary      | /\ |
 ### |              | \/ |
 ### ---------------------
 -->
<#macro html_item_single_line_float indent model>
${''?left_pad(indent)}<div class="item list-view-item">
${''?left_pad(indent)}  <div class="content" style="padding-top: 6px!important;">
${''?left_pad(indent)}    <a class="header">{{{primary}}}</a>
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}  <div class="image">
${''?left_pad(indent)}    <img src="{{{image}}}" style="width: 48px; height: 48px;">
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}</div>
</#macro>

<#--
 ### -------------------------------
 ### | primary        | tertiary   |
 ### | secondary      | quaternary |
 ### -------------------------------
 -->
<#macro html_item_two_line_float model>
${''?left_pad(indent)}<div class="item list-view-item" data-model-hospital-id="1" data-model-clinic-id="undefined" data-model-medical-service-schedule-id="1000413131202102221330">
${''?left_pad(indent)}  <div class="content">
${''?left_pad(indent)}    <div class="header">{{{primary}}}</div>
${''?left_pad(indent)}    <div class="ui two column grid mt-02">
${''?left_pad(indent)}      <div class="column left aligned">
${''?left_pad(indent)}        <div class="ui basic green tiny">
${''?left_pad(indent)}          <i class="fas fa-map-marked" style="margin-right: 10px;"></i>{{{secondary}}}
${''?left_pad(indent)}        </div>
${''?left_pad(indent)}      </div>
${''?left_pad(indent)}      <div class="column left aligned">
${''?left_pad(indent)}        <div class="ui basic green tiny">
${''?left_pad(indent)}          <i class="fas fa-user-friends" style="margin-right: 10px;"></i>{{{secondary}}}
${''?left_pad(indent)}        </div>
${''?left_pad(indent)}      </div>
${''?left_pad(indent)}    </div>
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}  <div class="image price" style="margin-left: 0!important;">
${''?left_pad(indent)}    <div class="ui basic font-20 right floated zigzag-green">
${''?left_pad(indent)}      <div style="position: absolute;top: 50%;left: 45%; transform: translateY(-50%) translateX(-50%); text-align: center;">
${''?left_pad(indent)}        <span>{{{tertiary}}}</span>
${''?left_pad(indent)}        <p class="font-12 mt-5">{{{quaternary}}}</p>
${''?left_pad(indent)}      </div>
${''?left_pad(indent)}    </div>
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
${''?left_pad(indent)}  {{{#each images}}}
${''?left_pad(indent)}  <div class="avatar avatar-36 tooltip-avatar">
${''?left_pad(indent)}    <img src="${r'${row.'}${model.image!'image'}${r'}'}">
${''?left_pad(indent)}    <span class="tooltip-text">{{{this}}}</span>
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}  {{{/each}}}
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
${''?left_pad(indent)}  <img src="{{{image}}}" height="32">
${''?left_pad(indent)}  <span>{{{primary}}}</span>
${''?left_pad(indent)}  <p class="detail">{{{secondary}}}</p>
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

<#------------------------------------------------------------------------------
 ###
 ### FIELD
 ###
 ------------------------------------------------------------------------------>

<#--
 ### ---------------------------
 ### |  primary  |  secondary  |
 ### ---------------------------
 -->
<#macro html_field_switch indent model>
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
<#macro html_field_tristate indent model>
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

<#------------------------------------------------------------------------------
 ###
 ### BLOCK
 ###
 ------------------------------------------------------------------------------>

<#macro html_block_properties indent model>
${''?left_pad(indent)}<div>
${''?left_pad(indent)}  <div class="title-bordered mb-2">
${''?left_pad(indent)}    <strong>{{{title}}}</strong>
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}  {{#each properties}}
${''?left_pad(indent)}  <div class="form form-horizontal">
${''?left_pad(indent)}    <div class="form-group row m-auto">
${''?left_pad(indent)}      <label class="col-md-2 col-form-label">
${''?left_pad(indent)}        <i class="fas fa-phone"></i>
${''?left_pad(indent)}      </label>
${''?left_pad(indent)}      <label class="col-md-10">
${''?left_pad(indent)}        {{#if scheme}}
${''?left_pad(indent)}        <a class="btn btn-link" href="tel:18987654321">{{{value}}}</a>
${''?left_pad(indent)}        {{else}}
${''?left_pad(indent)}        <strong>{{{value}}}</strong>
${''?left_pad(indent)}        {{/if}}
${''?left_pad(indent)}      </label>
${''?left_pad(indent)}    </div>
${''?left_pad(indent)}  </div>
${''?left_pad(indent)}  {{/each}}
${''?left_pad(indent)}</div>
</#macro>