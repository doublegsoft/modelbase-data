<#import '/$/modelbase.ftl' as modelbase>
const createRecycleContext = require('miniprogram-recycle-view')
const moment = require('../../../../vendor/moment/moment.min.js');
const { stdbiz } = require('../../../../common/${parentApplication}/remote-${app.name}.es6');

Component({
  
  properties: {

    limit: {
      type: 'integer'
    }
  },

  data: {
    inited: false,
    start: 0,
    params: {},
  },

  methods: {
    
    /*
    ** 初始化。
    */
    init() {
      this.ctx${js.nameType(modelbase.get_object_plural(entity))} = createRecycleContext({
        id: 'list${js.nameType(entity.name)}',
        dataKey: '${js.nameVariable(modelbase.get_object_plural(entity))}',
        page: this,
        itemSize: {
          height: (32 / 750) * wx.getSystemInfoSync().windowWidth,
          width: '100%'
        }
      });
    },

    /*
    ** 获取远程数据。
    */
    fetch: async function() {
      if (!this.data.inited) this.init();

      this.data.params.start = this.data.start;
      this.data.params.limit = parseInt(this.data.limit);

      let resp = await ${parentApplication}.${app.name}.paginate${js.nameType(modelbase.get_object_plural(entity))}(this.data.params);

      if (resp.error) {
        wx.showToast({
          title: '网络不给力，加载数据出错！',
        });
        return;
      }
      for (let i = 0; i < resp.data.length; i++) {
        let row = resp.data[i];
<#list entity.attributes as attr>
  <#if attr.type.name == 'datetime' || attr.type.name == 'date'>
        if (row.${modelbase.get_attribute_sql_name(attr)}) {
          row.${modelbase.get_attribute_sql_name(attr)} = moment(row.${modelbase.get_attribute_sql_name(attr)}).format('YYYY-MM-DD');
        }
  <#elseif attr.constraint.domainType.name?index_of('enum') == 0>
        row.${modelbase.get_attribute_sql_name(attr)} = ${parentApplication}.${app.name}.${entity.name?upper_case}_${attr.name?upper_case}[row.${modelbase.get_attribute_sql_name(attr)}];
  </#if>
</#list>
      }

      this.ctx${js.nameType(modelbase.get_object_plural(entity))}.append(resp.data);
    },

    search(params) {
      this.data.params = params || {};
      this.fetch();
    },

    /*
    ** 加载更多。
    */
    load(ev) {
      this.data.start += parseInt(this.data.limit);
      this.fetch();
    },

    /*
    ** 重新加载。
    */
    reload(ev) {
      this.ctxPatients.splice(0, this.data.start + parseInt(this.data.limit), []);
      this.data.start = 0;
      this.fetch();
    },
  }

})
