function show_upload_form(access_key, policy, signature, fname_hash, host) {
  $("div#upload-post").append(
    "<form id='upload-form' method='post' action='https://mixture-posts.s3.amazonaws.com/' enctype='multipart/form-data'>" + 
    "<input type='file' name='file' id='upload-button' onchange='upload(\"" + fname_hash +"\")'>" + 
    '<input type="hidden" name="AWSAccessKeyId" value="' + access_key + '">' + 
    '<input type="hidden" name="acl" value="public-read">' + 
    '<input type="hidden" name="success_action_redirect" value="' + host + '">' + 
    '<input type="hidden" name="policy" value="' + policy + '">' + 
    '<input type="hidden" name="signature" value="' + signature + '">' + 
    "</form>");
}

function getExtention(fileName) {
  var ret = "nil";
  if (!fileName) {
    return ret;
  }
  var fileTypes = fileName.split(".");
  var len = fileTypes.length;
  if (len === 0) {
    return ret;
  }
  ret = fileTypes[len - 1];
  return ret;
}

function getContentType(extension) {
  var content_type = ""
  if (extension != "nil") {
    switch (extension) {
      case "jpg":
      case "jpeg":
        content_type = "image/jpeg";
        break;
      case "png":
        content_type = "image/png"
        break;
      case "txt":
      case "csv":
        content_type = "text/plain";
        break;
      case "zip":
        content_type = "application/zip"
        break;
    }
  }
  return content_type;
}

function createAjaxForm(fname_hash, extension, content_type) {
  $('form#upload-form').append('<input type="hidden" name="key" value="' + "uploads/" + fname_hash + "." + extension + '">')
  $('form#upload-form').append('<input type="hidden" name="Content-Type" value="' + content_type + '">')
  var form = $('form#upload-form').get()[0];
  return new FormData(form);
}

function successCall(host) {
  $.ajax({
    type: "get",
    url: host + "post/succeeded/" + fname_hash + "/" + file_name
  });
}

function upload(fname_hash) {
  alert("start");
  var flist = document.getElementById("upload-button").files;
  var file_name = flist[0].name;
  var extension = getExtention(file_name).toLowerCase();
  var content_type = getContentType(extension);
  var form_data = createAjaxForm(fname_hash, extension, content_type);

  $.ajax({
    method: "post",
    url:  "https://mixture-posts.s3.amazonaws.com/",
    contentType: false,
    processData: false,
    data: form_data
  });
}