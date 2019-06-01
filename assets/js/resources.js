export function vote(resource_id, type){
    var req = new XMLHttpRequest();
    req.open('GET', '/resources/votes/' + resource_id + '/' + type, true);
    req.send(null);
}

export function submit_comment(path, textarea, csrf_token){
    var req = new XMLHttpRequest();
    req.open('POST', path);
    req.setRequestHeader("X-CSRF-Token", csrf_token);
    req.send(textarea.value);
    
    textarea.value = "";
}