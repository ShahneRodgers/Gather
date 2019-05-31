export function vote(resource_id, type){
    var req = new XMLHttpRequest();
    req.open('GET', '/resources/votes/' + resource_id + '/' + type, true);
    req.send(null);
}

export function submit_comment(resource_id, textarea, csrf_token){
    var req = new XMLHttpRequest();
    req.open('POST', '/resources/comment/' + resource_id);
    req.setRequestHeader("X-CSRF-Token", csrf_token);
    req.send(textarea.value);
    
    textarea.value = "";
}