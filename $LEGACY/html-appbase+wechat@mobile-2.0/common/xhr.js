/**
 * xhr will replace ajax which encapsulates jquery ajax in kui framework.
 * 
 * @since 2.0
 * 
 * @version 1.0.0 - Created on Jan 26, 2019.
 */
const xhr = {};

/**
* @private
*/
xhr.request = function (opts, method) {
  let url = opts.url;
  let data = opts.data || opts.params;
  let type = opts.type || 'json';
  let success = opts.success;
  let error = opts.error;

  let usecase = opts.usecase || ''; 

  let req  = new XMLHttpRequest();
  req.timeout = 10 * 1000;
  req.onload = function () {
    let resp = req.responseText;
    if (type == 'json')
      try {
        resp = JSON.parse(resp);
      } catch (err) {
        if (error) error(resp);
        return;
      }
    if (req.readyState == 4 && req.status == "200") {
      if (success) success(resp);
    } else {
      if (error) error(resp);
    }
  };
  req.onerror = function () {
    if (error) error({error: {code: -500, message: '网络访问错误！'}});
  };
  req.ontimeout = function () {
    if (error) error({error: {code: -501, message: '网络请求超时！'}});
  };
  req.open(method, url, true);
  req.setRequestHeader("Content-Type", "application/json");
  req.setRequestHeader("usecase", usecase);
  if (typeof APPTOKEN !== 'undefined') {
    req.setRequestHeader("apptoken", APPTOKEN);
  }
  if (data)
    req.send(JSON.stringify(data));
  else
    req.send(null);
};

/**
* @see xhr.request
*/
xhr.get = function (opts) {
  let url = opts.url;
  let data = opts.data;
  let success = opts.success;
  let error = opts.error;
  let req  = new XMLHttpRequest();
  req.open('GET', url, true);
  req.onload = function () {
    let resp = req.responseText;
    if (req.readyState == 4 && req.status == "200") {
      if (success) success(resp);
    } else {
      if (error) error(resp);
    }
  };
  req.send(null);
};

xhr.post = function (opts) {
  let url = opts.url;
  if (typeof HOST !== 'undefined' && url.indexOf('http') == -1) {
    url = HOST + url;
    opts.url = url;
  }
  xhr.request(opts, 'POST');
};

xhr.put = function (opts) {
  xhr.request(opts, 'PUT');
};

xhr.delete = function (opts) {
  xhr.request(opts, 'DELETE');
};

xhr.connect = function (opts) {
  xhr.request(opts, 'CONNECT');
};

xhr.upload = function(opts) {
  let url = opts.url;
  let params = opts.data || opts.params;
  let type = opts.type || 'json';
  let success = opts.success;
  let error = opts.error;

  let formdata = new FormData();
  for (let k in params) {
    formdata.append(k, params[k]);
  }
  formdata.append('file', opts.file);

  let req  = new XMLHttpRequest();
  req.timeout = 10 * 1000;
  req.onload = function () {
    let resp = req.responseText;
    if (type == 'json')
      try {
        resp = JSON.parse(resp);
      } catch (err) {
        if (error) error(resp);
        return;
      }
    if (req.readyState == 4 && req.status == "200") {
      if (success) success(resp);
    } else {
      if (error) error(resp);
    }
  };
  if (opts.progress) {
    req.onprogress = function(ev) {
      opts.progress(ev.loaded, ev.total);
    };
  }
  req.onerror = function () {
    if (error) error({error: {code: -500, message: '网络访问错误！'}});
  };
  req.ontimeout = function () {
    if (error) error({error: {code: -501, message: '网络请求超时！'}});
  };
  req.open('POST', url, true);
  if (typeof APPTOKEN !== 'undefined') {
    req.setRequestHeader("apptoken", APPTOKEN);
  }
  req.send(formdata);
};

xhr.chain = function(opts) {
  if (opts.length == 0) return;
  let xhrOpts = opts[0];
  let successProxy = xhrOpts.success;
  let then = function(resp) {
    successProxy(resp);
    xhr.chain(opts.slice(1));
  };
  xhr.promise(xhrOpts, then);
};

xhr.promise = function(xhrOpt) {
  return new Promise(function(resolve, reject) {
    wx.request({
      url: 'http://localhost:9876' + xhrOpt.url,
      method: 'POST',
      header: {
        'content-type': 'application/json',
        'apptoken': '1234567',
      },
      data: xhrOpt.params || {},
      success: function(resp) {
        resolve(resp.data);
      },
      fail: function(resp) {
        reject(resp);
      }
    });
  });
};
 
module.exports = { xhr };