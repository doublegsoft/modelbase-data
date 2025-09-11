<#import "/$/modelbase.ftl" as modelbase>
<#import "/$/appbase.ftl" as appbase>
const ${app.name} = {};
<#assign methodAndWidgets = {}>
<#list pages![] as page>
  <#assign pageName = modelbase.url_to_page_name(page.uri)>
  <#list page.widgets as widget>
    <#assign variable = widget.variable!'todo'>
    <#if widget.widgetType == '滚动导航'>
      <#assign methodAndWidgets = methodAndWidgets + {('load' + js.nameType(variable) + '4' + js.nameType(pageName)): widget}>
    <#elseif widget.widgetType == '滑动导航'>
      <#assign methodAndWidgets = methodAndWidgets + {('load' + js.nameType(variable) + '4' + js.nameType(pageName)): widget}>
    <#elseif widget.widgetType == '栏位导航'>
      <#assign methodAndWidgets = methodAndWidgets + {('load' + js.nameType(variable) + '4' + js.nameType(pageName)): widget}>
    <#elseif widget.widgetType == '传统列表' || widget.widgetType == 'ListView'>
      <#assign methodAndWidgets = methodAndWidgets + {('load' + js.nameType(variable) + '4' + js.nameType(pageName)): widget}>
    <#elseif widget.widgetType == '编辑表单' || widget.widgetType == 'FormLayout'>
      <#assign methodAndWidgets = methodAndWidgets + {('save' + js.nameType(variable) + '4' + js.nameType(pageName)): widget}>
      <#assign methodAndWidgets = methodAndWidgets + {('read' + js.nameType(variable) + '4' + js.nameType(pageName)): widget}>
    <#elseif widget.widgetType == '只读表单' || widget.widgetType == 'ReadonlyForm'>
      <#assign methodAndWidgets = methodAndWidgets + {('read' + js.nameType(variable) + '4' + js.nameType(pageName)): widget}>
    <#elseif widget.widgetType == '花式表单' || widget.widgetType == 'StyledForm'>
      <#assign methodAndWidgets = methodAndWidgets + {('read' + js.nameType(variable) + '4' + js.nameType(pageName)): widget}>
    </#if>
  </#list>
</#list>
<#-- 固定枚举值 -->
${app.name}.options = {
<#list pages![] as page>
  <#list page.widgets as widget>
    <#if widget.widgetType == '编辑表单'>
      <#list widget.customForm.fields as field>
        <#assign fieldName = field.name!field.title>
        <#if field.input == 'select'>
  '${js.nameType(fieldName)}': {
    values: [{
      text: '选项A', value: 'A',
    }, {
      text: '选项B', value: 'B',
    },{
      text: '选项C', value: 'C',
    }]
  },
        <#elseif field.input == 'radio'>
  '${js.nameType(fieldName)}': {
    values: [{
      text: '单选A', value: 'A',
    }, {
      text: '单选B', value: 'B',
    },{
      text: '单选C', value: 'C',
    }]
  },
        <#elseif field.input == 'check'>
  '${js.nameType(fieldName)}': {
    values: [{
      text: '复选A', value: 'A',
    }, {
      text: '复选B', value: 'B',
    },{
      text: '复选C', value: 'C',
    }]
  },
        </#if>
      </#list>
    </#if>
  </#list>
</#list>
};

${app.name}.options.getText = (name, value) => {
  if (!value) return '';
  if (!${app.name}.options[name]) return value;
  let opt = ${app.name}.options[name];
  if (!opt.values) return value;
  if (Array.isArray(value)) {
    let text = '';
    for (let v of value) {
      if (text != '') text += '，';
      for (let row of opt.values) {
        if (row.value === v) {
          text += row.text;
          break;
        }
      }
    }
    return text;
  } else {
    for (let row of opt.values) {
      if (row.value === value) {
        return row.text;
      }
    }
  }
  return '';
}

<#assign methods = methodAndWidgets?keys?sort>
<#list methods as method>

  <#assign widget = methodAndWidgets[method]>
  <#if method?starts_with('load')>
/**
 * 加载【${widget.variable?upper_case}】数据。
 */
${app.name}.${method} = async (params) => {
  let start = params.start || 0;
  let limit = params.limit || -1;
    <#if widget.widgetType == '滚动导航'>
  return [{
    "image": "http://localhost:8888/img/placeholder/600x200.png",
    "url": "",
  },{
    "image": "http://localhost:8888/img/placeholder/600x200.png",
    "url": "",
  },{
    "image": "http://localhost:8888/img/placeholder/600x200.png",
    "url": "",
  }];
    <#elseif widget.widgetType == '滑动导航'>
  return [{
    "image": "http://localhost:8888/img/placeholder/120x80.png",
    "url": "",
  },{
    "image": "http://localhost:8888/img/placeholder/120x80.png",
    "url": "",
  },{
    "image": "http://localhost:8888/img/placeholder/120x80.png",
    "url": "",
  },{
    "image": "http://localhost:8888/img/placeholder/120x80.png",
    "url": "",
  },{
    "image": "http://localhost:8888/img/placeholder/120x80.png",
    "url": "",
  }];
    <#elseif widget.widgetType == '栏位导航'>
  return {
    "primary": {
      "image": "http://localhost:8888/img/placeholder/300x450.png",
      "url": "",
    },
    "secondary": {
      "image": "http://localhost:8888/img/placeholder/240x150.png",
      "url": "",
    },
    "tertiary": {
      "image": "http://localhost:8888/img/placeholder/240x150.png",
      "url": "",
    }
  };
    <#else>
  return [{
    "${widget.tile.primary!'primary'}": "主要文本A",
    "${widget.tile.secondary!'secondary'}": "次要文本A",
    "${widget.tile.tertiary!'tertiary'}": "再次文本A",
    "${widget.tile.quaternary!'quaternary'}": "最次文本A",
    "${widget.tile.avatar!'avatar'}": "http://localhost:8888/img/user.png",
    "${widget.tile.image!'image'}": "http://localhost:8888/img/under-construction.jpeg",
    "${widget.tile.status!'status'}": "正常",
  },{
    "${widget.tile.primary!'primary'}": "主要文本B",
    "${widget.tile.secondary!'secondary'}": "次要文本B",
    "${widget.tile.tertiary!'tertiary'}": "再次文本B",
    "${widget.tile.quaternary!'quaternary'}": "最次文本B",
    "${widget.tile.avatar!'avatar'}": "http://localhost:8888/img/user.png",
    "${widget.tile.image!'image'}": "http://localhost:8888/img/under-construction.jpeg",
    "${widget.tile.status!'status'}": "正常",
  },{
    "${widget.tile.primary!'primary'}": "主要文本C",
    "${widget.tile.secondary!'secondary'}": "次要文本C",
    "${widget.tile.tertiary!'tertiary'}": "再次文本C",
    "${widget.tile.quaternary!'quaternary'}": "最次文本C",
    "${widget.tile.avatar!'avatar'}": "http://localhost:8888/img/user.png",
    "${widget.tile.image!'image'}": "http://localhost:8888/img/under-construction.jpeg",
    "${widget.tile.status!'status'}": "正常",
  },{
    "${widget.tile.primary!'primary'}": "主要文本D",
    "${widget.tile.secondary!'secondary'}": "次要文本D",
    "${widget.tile.tertiary!'tertiary'}": "再次文本D",
    "${widget.tile.quaternary!'quaternary'}": "最次文本D",
    "${widget.tile.avatar!'avatar'}": "http://localhost:8888/img/user.png",
    "${widget.tile.image!'image'}": "http://localhost:8888/img/under-construction.jpeg",
    "${widget.tile.status!'status'}": "正常",
  },{
    "${widget.tile.primary!'primary'}": "主要文本E",
    "${widget.tile.secondary!'secondary'}": "次要文本E",
    "${widget.tile.tertiary!'tertiary'}": "再次文本E",
    "${widget.tile.quaternary!'quaternary'}": "最次文本E",
    "${widget.tile.avatar!'avatar'}": "http://localhost:8888/img/user.png",
    "${widget.tile.image!'image'}": "http://localhost:8888/img/under-construction.jpeg",
    "${widget.tile.status!'status'}": "正常",
  },{
    "${widget.tile.primary!'primary'}": "主要文本F",
    "${widget.tile.secondary!'secondary'}": "次要文本F",
    "${widget.tile.tertiary!'tertiary'}": "再次文本F",
    "${widget.tile.quaternary!'quaternary'}": "最次文本F",
    "${widget.tile.avatar!'avatar'}": "http://localhost:8888/img/user.png",
    "${widget.tile.image!'image'}": "http://localhost:8888/img/under-construction.jpeg",
    "${widget.tile.status!'status'}": "正常",
  }];
    </#if>
};
  <#elseif method?starts_with('save')>
/**
 * 保存【${widget.variable?upper_case}】数据。
 */
${app.name}.${method} = async (${js.nameVariable(widget.variable)}) => {
  console.log(${js.nameVariable(widget.variable)});
  return ${js.nameVariable(widget.variable)};
};
  <#elseif method?starts_with('read')>
/**
 * 读取【${widget.variable?upper_case}】数据。
 */
${app.name}.${method} = async (id) => {
  <#assign custom = {}>
  <#if widget.customReadonly??>
    <#assign custom = widget.customReadonly>
  <#elseif widget.customForm??>
    <#assign custom = widget.customForm>
  <#elseif widget.customStyled??>
    <#assign custom = widget.customStyled>
  </#if>
  <#if custom?keys?size == 0>
  return {};
  <#else>
  return {
    <#list custom.fields as field>
      <#if field.input == 'date'>
    '${field.name!field.title?trim}': '2023-06-01',
      <#elseif field.input == 'time'>
    '${field.name!field.title?trim}': '18:00:00',
      <#elseif field.input == 'bool'>
    '${field.name!field.title?trim}': 'T',
      <#elseif field.input == 'ruler'>
    '${field.name!field.title?trim}': '66',
      <#elseif field.input == 'select'>
    '${field.name!field.title?trim}': 'A',
      <#elseif field.input == 'radio'>
    '${field.name!field.title?trim}': 'B',
      <#elseif field.input == 'check'>
    '${field.name!field.title?trim}': ['B'],
      <#elseif field.input == 'district'>
    '${field.name!field.title?trim}': {
      provinceCode: '50',
      cityCode: '5001',
      countyCode: '500103',
      provinceName: '重庆市',
      cityName: '市辖区',
      countyName: '渝中区',
    },
      <#elseif field.input == 'images'>
    '${field.name!field.title?trim}': [{
      url: 'http://localhost:8888/img/brand.png',
    },{
      url: 'http://localhost:8888/img/under-construction.jpeg'
    }],
      <#elseif field.input == 'longtext'>
    '${field.name!field.title?trim}': '要全面贯彻党的二十大精神，深刻认识国家安全面临的复杂严峻形势，正确把握重大国家安全问题',
      <#-- 花式表单特有的字段 -->
      <#elseif field.input == 'single'>
    "${field.name!field.title?trim}": "C",
      <#elseif field.input == 'successive'>
    "${field.name!field.title?trim}": "C",
      <#elseif field.input == 'multiple'>
    "${field.name!field.title?trim}": ["B", "C", "E"],
      <#else>
    '${field.name!field.title?trim}': '${field.title?trim}',
      </#if>
    </#list>
  };
  </#if>
};
  </#if>
</#list>

module.exports = { ${app.name} };