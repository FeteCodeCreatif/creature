getCompleteSource = function(codefragment) {

  $.get(

    "creatureclass/creatureclass.pde",

    function(text) {

      console.log(text);

      var template = text;
      var usercode = codefragment;

      var match = /\/\/kids code here/;

      var sourcecode = template.replace(match, usercode);
      console.log(sourcecode);

      return sourcecode;


    },

    "text");

};