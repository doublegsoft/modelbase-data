<#import '/$/modelbase.ftl' as modelbase>
<div id="page${js.nameType(entity.name)}Log" class="card b-a-0">
  <div widget-id="widget${js.nameType(entity.name)}Log" class="card-body mb-3">
    <ul widget-id="widgetPastControlLevel" class="timeline-ia">
      <li class="timeline-item">
        <div class="time">首诊&nbsp;&nbsp;2020-06-29</div>
        <div class="small text-muted">重庆市妇幼保健院</div>
        <p>控制水平评估:&nbsp;&nbsp;量表评估：TRACK结论：得到控制</p>
      </li>
    </ul>
  </div>

<script>

function Page${js.nameType(entity.name)}Log() {
  
}

Page${js.nameType(entity.name)}Log.prototype.show = function (params) {
  let self = this;
  stdbiz.${app.name}.option${js.nameType(entity.name)}({
    customElementId: 'FORM.${entity.name?upper_case}.Log' 
  }, function(option) {
    option.columnCount = 1;
    option.fields = option.children;
    self.form${js.nameType(entity.name)}Log = new FormLayout(option);
    self.setup(params);
  });
};

Page${js.nameType(entity.name)}Log.prototype.initialize = function (params) {
  this.form${js.nameType(entity.name)}Log.render('#page${js.nameType(entity.name)}Log div[widget-id=form${js.nameType(entity.name)}Log]', params);
};

page${js.nameType(entity.name)}Log = new Page${js.nameType(entity.name)}Log();

</script>
</div>