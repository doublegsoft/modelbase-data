<#import '/$/modelbase.ftl' as modelbase>
<#assign alias = desktop.getLabelledOptions('desktop')['alias']!desktop.name>
<#assign domainType = profile.constraint.domainType.toString()>
<div id="page${js.nameType(alias)}Code" class="page full background-shade fade fadeIn">
  <div class="card-body">
    <div class="editor">
      <div class="editor-toolbar">
        <span class="button-group">
          <a widget-id="buttonClose" class="button text-danger"><i class="fas fa-times"></i></a>
        </span>
        <span class="separator"></span>
        <span class="button-group">
          <a widget-id="buttonSave" class="button"><i class="fas fa-save"></i></a>
          <a widget-id="buttonCopy" class="button"><i class="far fa-copy"></i></a>
          <a widget-id="buttonValidate" class="button"><i class="fas fa-clipboard-check"></i></a>
        </span>
      </div>
      <textarea name="longtextSourceCode" class="form-control"></textarea>
    </div>
  </div>
</div>
<script>
function Page${js.nameType(alias)}Code() {
  this.page = dom.find('#page${js.nameType(alias)}Code');
};

Page${js.nameType(alias)}Code.prototype.setup = function(params) {
  let self = this;
  let textarea = dom.find('#page${js.nameType(alias)}Code textarea[name=longtextSourceCode]');
  textarea.innerHTML = data.source;
  dom.bind('#page${js.nameType(alias)}Code', 'click', function(event) {
    if (event.target.id === 'page${js.nameType(alias)}Code')
      this.remove();
  });
  this.editor = CodeMirror.fromTextArea(textarea, {
    mode: 'sql',
    lineNumbers: true,
    height: '750px',
    tabSize: 2,
    background: '#565656'
  });
  this.editor.setSize('100%', (window.innerHeight - 45 - 25 - 10));

  dom.bind('#page${js.nameType(alias)}Code a[widget-id=buttonClose]', 'click', function() {
    dom.find('#page${js.nameType(alias)}Code').remove();
  });
  dom.bind('#page${js.nameType(alias)}Code a[widget-id=buttonSave]', 'click', function() {
    xhr.post({
      url: '/api/v3/common/script/guardwatch/dataset/save',
      params: {
        datasetExtractionId: self.datasetExtractionId,
        source: self.editor.getValue()
      },
      success: function(resp) {
        if (resp.error) {
          toast.error('#page${js.nameType(alias)}Code div.card', resp.error.message);
          return;
        }
        toast.success('#page${js.nameType(alias)}Code div.card', '语句成功保存！');
      }
    });
  });
  dom.bind('#page${js.nameType(alias)}Code a[widget-id=buttonCopy]', 'click', function() {
    navigator.clipboard.writeText(self.editor.getValue()).then(function(data) {
      toast.info('#page${js.nameType(alias)}Code div.card', '已复制到粘贴板！');
    }, function(err) {
      toast.error('#page${js.nameType(alias)}Code div.card', '复制到粘贴板失败！');
    });

  });
  dom.bind('#page${js.nameType(alias)}Code a[widget-id=buttonValidate]', 'click', function() {
    xhr.post({
      url: '/api/v3/common/script/guardwatch/dataset/validate',
      params: {
        sql: self.editor.getValue()
      },
      success: function(resp) {
        if (resp.error) {
          toast.error('#page${js.nameType(alias)}Code div.card', resp.error.message);
          return;
        }
        toast.success('#page${js.nameType(alias)}Code div.card', '语法验证成功！');
      }
    })
  });
};

Page${js.nameType(alias)}Code.prototype.show = function(params) {
  this.setup(params);
};

page${js.nameType(alias)}Code = new Page${js.nameType(alias)}Code();
</script>