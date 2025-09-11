
<#macro print_methods_of_list_view obj indent>
${''?left_pad(indent)}/**
${''?left_pad(indent)} * scroll-view滑到底部触发事件
${''?left_pad(indent)} * @method scrollMytrip
${''?left_pad(indent)} */
${''?left_pad(indent)}async scrollMytrip() {
${''?left_pad(indent)}  try {
${''?left_pad(indent)}    const { page, list, } = this.data;
${''?left_pad(indent)}    // 判断是否还有数据需要加载
${''?left_pad(indent)}    if (list.length < mockTotal) {
${''?left_pad(indent)}      this.setData({ show: true });
${''?left_pad(indent)}      const newPage = page + 1;
${''?left_pad(indent)}      this.mySchedulde(newPage);
${''?left_pad(indent)}    }
${''?left_pad(indent)}  } catch (e) {
${''?left_pad(indent)}    this.setData({ show: false });
${''?left_pad(indent)}    console.log('scrollMytrip执行异常:', e);
${''?left_pad(indent)}  }
${''?left_pad(indent)}},
${''?left_pad(indent)}
${''?left_pad(indent)}/**
${''?left_pad(indent)} * 模拟请求服务端查询数据并渲染页面
${''?left_pad(indent)} * @method mySchedulde
${''?left_pad(indent)} * @param {int} page 分页,默认第1页
${''?left_pad(indent)} */
${''?left_pad(indent)}async mySchedulde(page = 1) {
${''?left_pad(indent)}  try {
${''?left_pad(indent)}    let list = this.data.list;
${''?left_pad(indent)}    // 模拟请求拿到数据进行更新data
${''?left_pad(indent)}    setTimeout(() => {
${''?left_pad(indent)}      let data = mockData;
${''?left_pad(indent)}      for (let i = 0; i < data.length; i++) {
${''?left_pad(indent)}        let newObj = { ...data[i], remarksa: `我是第${page}页` };
${''?left_pad(indent)}        list.push(newObj);
${''?left_pad(indent)}      }
${''?left_pad(indent)}      this.setData({
${''?left_pad(indent)}        list,
${''?left_pad(indent)}        page,
${''?left_pad(indent)}        show: false
${''?left_pad(indent)}      });
${''?left_pad(indent)}    }, 1000);
${''?left_pad(indent)}  } catch (e) {
${''?left_pad(indent)}    console.log('mySchedulde执行异常:', e);
${''?left_pad(indent)}  }
${''?left_pad(indent)}}
</#macro>