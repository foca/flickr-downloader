(function() {
	function generatingZip() {
	  this.up("li").addClassName("downloading");
	  this.hide();
	  new PeriodicalExecuter(checkZip.curry(this.readAttribute("href").gsub(/\D+/, ""), this), 2);
	}

	function zipReady() {
	  this.up("li").removeClassName("downloading");
	  this.show();
	}

	function checkZip(id, link, executer) {
	  new Ajax.Request("/status/" + id, { 
	    method: "get", 
	    on200: function() { executer.stop(); zipReady.apply(link) }
	  });
	}

	document.observe("dom:loaded", function() {
	  $$("li a").invoke("observe", "click", generatingZip);
	});
})();