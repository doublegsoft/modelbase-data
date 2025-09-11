<#import '/$/modelbase.ftl' as modelbase>
import * as echarts from '../../../../vendor/ec-canvas/echarts';
const moment = require('../../../../vendor/moment/moment.min.js');
const { appbase } = require('../../../../common/appbase');
const { stdbiz } = require('../../../../common/${parentApplication}/remote-${app.name}.es6');

<#assign attrId = modelbase.get_id_attributes(entity)[0]>
const app = getApp();

Component({

  data: {
    ec: {
      lazyLoad: true,
    },
  },

  methods: {
    
    async render(params) {
      this.line${js.nameType(entity.name)} = this.selectComponent('#_line_${entity.name}');
      let resp = await ${parentApplication}.${app.name}.aggregate${js.nameType(modelbase.get_object_plural(entity))}({
        state: 'E',
        groupingFields: [{
          persistenceName: 'gncd',
          attributeName: 'genderCode',
        }],
        aggregateFields: [{
          operator: 'count',
          persistenceName: '${attrId.persistenceName}',
          attributeName: '${modelbase.get_attribute_sql_name(attrId)}',
        }]
      });

      if (resp.error) {
        wx.showToast({
          title: '程序出错了，可能网络不给力'
        });
        return;
      }

      var option = appbase.optionEChartsLine({
        values: [{
          name: 'count${js.nameType(modelbase.get_attribute_sql_name(attrId))}',
          text: '${modelbase.get_object_label(entity)}',
          operator: 'sum',
          color: '#283593'
        }],
        category: {
          name: 'genderCode',
        },
        data: resp.data,
      });

      this.line${js.nameType(entity.name)}.init((canvas, width, height, dpr) => {
        const chart = echarts.init(canvas, null, {
          width: width,
          height: height,
          devicePixelRatio: dpr
        });
        canvas.setChart(chart);
        chart.setOption(option);
        return chart;
      });
    }

  },
});


