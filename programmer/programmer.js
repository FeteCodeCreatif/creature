(function() {
  "use strict";

  // thanks https://gist.github.com/jlong/2428561
  var creaturename = window.location.hash.slice(1);
  console.log(creaturename);

  io = io.connect('http://paysage.herokuapp.com:80');

  document.getElementById('bouton').addEventListener('click',
    function(){
      var codeid = document.getElementById('codeid').value;
      var playgroundid = document.getElementById('playgroundid').value;
      var code = document.getElementById('code').value;
      code = getCompleteSource(code);
      var data = {codeid: codeid, playgroundid: playgroundid, code: code};
      io.emit('code update', data);
    });

  io.on('objects full update', function (data) {
    var playgroundId = data.playgroundId,
        objectIds = data.objectIds,
        $objects = $("#objects");
    $objects.empty();
    $objects.append(objectIds.map(function (objectId) {
      var $item = $("<a href='#'>").text(objectId);
      $item.click(function (event) {
        event.preventDefault();
        var data = {playgroundId: playgroundId, objectId: objectId};
        io.emit('request code', data);
      });
      return $('<li>').append($item);
    }));
  });

  io.on('source code', function (data) {
    $("#playgroundid").val(data.playgroundId);
    $("#codeid").val(data.objectId);
    $("#code").val(data.code);
  });

  io.emit('programmer up', document.getElementById('playgroundid').value);



   $('.creature').click(function () {
    $('#codeid').val(creaturename);
    $('#code').val($('script', this).html());
  });

  $(function() {
    $('#codeid').val(creaturename);
  });

}());
