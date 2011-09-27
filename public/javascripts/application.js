// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
function checkUncheckAll(theElement) {
var theForm = theElement.form, z = 0;
for(z=0; z<theForm.length;z++){
if(theForm[z].type == 'checkbox' && theForm[z].name != 'checkall'){
theForm[z].checked = theElement.checked;
}
}
} 