
const appbase = {};

appbase.login = function () {
  return new Promise((resolve, reject) => {
    wx.login({
      success: function (res) {
        const code = res.code
        let referrer = '' // 推荐人
        let referrer_storge = wx.getStorageSync('referrer');
        if (referrer_storge) {
          referrer = referrer_storge;
        }
        // 下面开始调用注册接口
        const componentAppid = wx.getStorageSync('componentAppid')
        if (componentAppid) {
          WXAPI.wxappServiceAuthorize({
            code: code,
            referrer: referrer
          }).then(function (res) {
            if (res.code == 0) {
              wx.setStorageSync('token', res.data.token)
              wx.setStorageSync('uid', res.data.uid)
              resolve(res)
            } else {
              wx.showToast({
                title: res.msg,
                icon: 'none'
              })
              reject(res.msg)
            }
          })
        } else {
          WXAPI.authorize({
            code: code,
            referrer: referrer
          }).then(function (res) {
            if (res.code == 0) {
              wx.setStorageSync('token', res.data.token)
              wx.setStorageSync('uid', res.data.uid)
              resolve(res)
            } else {
              wx.showToast({
                title: res.msg,
                icon: 'none'
              })
              reject(res.msg)
            }
          })
        }
      },
      fail: err => {
        reject(err)
      }
    })
  })
};

appbase.takePicture = function() {
  return new Promise((resolve, reject) => {
    const ctx = wx.createCameraContext();
    ctx.takePhoto({
      quality: 'high',
      success: (res) => {
        resolve(res);
      }
    });
  });
};

appbase.choosePicture = function() {
  return new Promise((resolve, reject) => {
    wx.chooseImage({
      count: 1,
      sizeType: ['original', 'compressed'],
      sourceType: ['album', 'camera'],
      success (res) {
        resolve(res);
      }
    })
  });
};

appbase.recordAudio = function() {
  return new Promise((resolve, reject) => {
    wx.startRecord({
      success(res) {
        const tempFilePath = res.tempFilePath
      },
      complete(res) {
        resolve(res);
      }
    })
  });
};

appbase.phoneCall = function(params) {
  wx.makePhoneCall({
    phoneNumber: params.phoneNumber,
  })
};

appbase.scanCode = function() {
  return new Promise((resolve, reject) => {
    wx.scanCode({
      onlyFromCamera: true,
      success (res) {
        resolve(res);
      }
    });
  });
};

appbase.getLocation = function() {
  return new Promise((resolve, reject) => {
    wx.getLocation({
      type: 'wgs84',
      success (res) {
        resolve(res);
      }
    });
  });
};

appbase.optionChart = function(options) {
  let color = [];
  let data = options.data || [];
  let category = options.category;
  let values = options.values;

  // group field means chart legend
  let dataLegend = [];
  let hashLegend = {};

  let hashCategory = {};

  // 填充category数据
  for (let i = 0; i < data.length; i++) {
    let row = data[i];

    // 这一行所属的类别
    let valueCategory = row[category.name];
    let textCategory = valueCategory;

    // 如果是图例，则要收集图例的数据
    if (category.values && category.values[valueCategory]) {
      textCategory = category.values[valueCategory].text;
      textCategory = (typeof textCategory === 'undefined') ? valueCategory : textCategory;
    }
    if (typeof hashCategory[textCategory] === 'undefined') {
      // 注意此处的数据结构
      hashCategory[textCategory] = {name: textCategory, values: []};
    }

    // 收集category的数据
    for (let j = 0; j < values.length; j++) {
      let valueValue = row[values[j].name];
      if (typeof hashCategory[textCategory].values[j] === 'undefined')
        hashCategory[textCategory].values[j] = {};
      if (values[j].operator === 'sum') {
        if (typeof hashCategory[textCategory].values[j]['sum'] === 'undefined')
          hashCategory[textCategory].values[j]['sum'] = [];
        hashCategory[textCategory].values[j]['sum'].push(valueValue);
      } else {
        // operator为某个字段名，意味着以operator字段作为legend分别计算
        let valueOperator = row[values[j].operator];
        // 编码转文本
        if (values[j].values && values[j].values[valueOperator]) {
          valueOperator = values[j].values[valueOperator].text;
        }
        if (typeof hashCategory[textCategory].values[j][valueOperator] === 'undefined')
          hashCategory[textCategory].values[j][valueOperator] = [];
        hashCategory[textCategory].values[j][valueOperator].push(valueValue);
        // 注意此处，从value的operator指定的字段中获取subcategory的值
        hashLegend[valueOperator] = valueOperator;
      }
    }
  }

  if (category.legend) {
    // 图例的数据来源来自于分类的数据
    for (let textCategory in hashCategory) {
      dataLegend.push(textCategory);
      for (let i = 0; i < values.length; i++) {
        if (values[i].operator === 'sum') {
          let sum = hashCategory[textCategory].values[i]['sum'].reduce(function (a, b) {
            return a + b;
          }, 0);
          hashCategory[textCategory].values[i]['sum'] = sum;
        }
      }
    }
  } else {
    // 图例的数据来源于值的定义
    for (let i = 0; i < values.length; i++) {
      if (values[i].operator === 'sum') {
        dataLegend.push(values[i].text);
      } else {
        if (i == 0) {
          // 动态的图例数据，来源于值域中的operator值，相当于把subcategory作为图例
          for (let key in hashLegend)
            dataLegend.push(key);
        }
      }
      for (let textCategory in hashCategory) {
        if (values[i].operator === 'sum') {
          // 需要求和
          let sum = hashCategory[textCategory].values[i]['sum'].reduce(function (a, b) {
            return a + b;
          }, 0);
          // 把数组转换为数字
          hashCategory[textCategory].values[i]['sum'] = sum;
        } else {
          for (let key in hashCategory[textCategory].values[i]) {
            // 把数组转换为数字
            hashCategory[textCategory].values[i][key] = hashCategory[textCategory].values[i][key][0];
          }
        }
      }
    }
  } // if (category.legend)

  // compatible echarts option
  let ret = {
    legend: {
      data: dataLegend
    },
    categories: hashCategory
  };
  if (options.tooltip) {
    ret.tooltip = {
      formatter: options.tooltip
    }
  }
  if (color.length > 0) ret.color = color;
  return ret;
};

appbase.optionPie = function(options) {
  let echartOptions = appbase.optionChart(options);
  echartOptions.tooltip = echartOptions.tooltip || {};

  // series
  let seriesData = [];
  for (let category in echartOptions.categories) {
    seriesData.push({
      name: echartOptions.categories[category].name,
      value: echartOptions.categories[category].values[0][options.values[0].operator]
    });
  }

  // series color
  for (let i = 0; i < seriesData.length; i++) {
    for (let key in options.category.values) {
      if (seriesData[i].name == options.category.values[key].text) {
        seriesData[i].color = options.category.values[key].color;
        break;
      }
    }
  }
  echartOptions.series = [{
    type: 'pie',
    data: seriesData
  }];
  echartOptions.legend.show = false;

  return echartOptions;
};

appbase.optionBar = function(options) {
  let echartOptions = appbase.optionChart(options);

  let series = [];
  let xAxis = {type: 'category', data: []};
  for (let i = 0; i < options.values.length; i++) {
    let seriesItem = {
      name: options.values[i].text,
      type: 'bar',
      data: []
    };
    if (options.values[i].color) {
      seriesItem.itemStyle = {color: options.values[i].color};
    }
    // 填充数值
    for (let textCategory in echartOptions.categories) {
      if (i == 0) xAxis.data.push(textCategory);
      let values = echartOptions.categories[textCategory].values;
      seriesItem.data.push(values[i][options.values[i].operator]);
    }
    series.push(seriesItem);
  }

  echartOptions.tooltip = echartOptions.tooltip || {};
  echartOptions.xAxis = xAxis;
  echartOptions.series = series;
  echartOptions.yAxis = {};

  return echartOptions;
};

appbase.optionLine = function(options) {
  let echartOptions = appbase.optionChart(options);
  let series = [];
  let xAxis = {type: 'category', data: []};
  for (let i = 0; i < options.values.length; i++) {
    let seriesItem = {
      name: options.values[i].text,
      type: options.values[i].type || 'line',
      data: [],
    };
    if (options.values[i].color) {
      seriesItem.itemStyle = {color: options.values[i].color};
    }
    for (let textCategory in echartOptions.categories) {
      if (i == 0) xAxis.data.push(textCategory);
      let values = echartOptions.categories[textCategory].values;
      if (seriesItem.type === 'scatter') {
        seriesItem.symbolSize = 6;
        if (values[i][options.values[i].operator] > 0) {
          seriesItem.data.push([textCategory, values[i][options.values[i].operator]]);
        }
      } else {
        seriesItem.data.push(values[i][options.values[i].operator]);
      }
    }
    series.push(seriesItem);
  }
  echartOptions.tooltip = echartOptions.tooltip || {};
  echartOptions.xAxis = xAxis;
  echartOptions.series = series;
  echartOptions.yAxis = {
    splitLine: {
      show: false
    }
  };

  return echartOptions;
};

module.exports = { appbase };