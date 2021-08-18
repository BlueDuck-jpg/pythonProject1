document.getElementById("mybutton").onclick = function(){

    var ok = document.getElementById("myquestion").value;
    var no = document.getElementById("discord").value;

    const whurl = "https://discord.com/api/webhooks/868293856213495808/9KFwZnD4oIrBqhTfDkMuV_v6MvDsWkz220F3dj-4vfZVtqiE3v44djiUMevFlGqDO-s0"

    const msg = {
        "content": ok + "\n" + no
    }


    fetch(whurl, {"method": "POST", "headers": {"content-type": "application/json"}, "body": JSON.stringify(msg)})
    
}