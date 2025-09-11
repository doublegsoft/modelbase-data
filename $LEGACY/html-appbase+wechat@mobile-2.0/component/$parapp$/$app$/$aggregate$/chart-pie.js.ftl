import * as echarts from '../../../../vendor/ec-canvas/echarts';
const moment = require('../../../../vendor/moment/moment.min.js');
const { appbase } = require('../../../../common/appbase');
const { stdbiz } = require('../../../../common/${parentApplication}/remote-${app.name}.es6');

const app = getApp();

Component({

  data: {
    ec: {},
  },

  methods: {
    
    async render(params) {
      var option = appbase.optionEChartsPie({

      });

      this.setData({
        ec: {
          onInit: (canvas, width, height, dpr) => {
            const chart = echarts.init(canvas, null, {
              width: width,
              height: height,
              devicePixelRatio: dpr
            });
            canvas.setChart(chart);
            chart.setOption(option);
            return chart;
          }
        }
      })
    }

  },
});
