const formContainer = document.getElementById('formContainer');
const lobbieContainer = document.getElementById('container');
const lobbie = document.getElementById('lobbie');

var formInfo = {
    lobbiename: document.getElementById('lobbiename'),
    lobbieid: document.getElementById('lobbieid'),
    filename: document.getElementById('filename'),
    population: document.getElementById('population'),
    lockdown: document.getElementById('lockdown'),
    price: document.getElementById('price'),
    lobbietype: document.getElementById('lobbietype'),
}

window.addEventListener('message', ({ data }) => {
    if (data.color) {
        lobbie.style.background = data.color;
    }
    if (data.type == "newSetup") {
        data.enable ? formContainer.style.display = "flex" : formContainer.style.display = "none";
        data.enable ? lobbieContainer.style.display = "none" : lobbieContainer.style.display = "block";

    } else if (data.type == "display") {
        if (data.text !== undefined) {
            lobbie.style.display = 'block';
            lobbie.innerHTML = data.text;
            lobbie.classList.add('slide-in');
        }
    } else if (data.type == "hide") {
        park.classList.add('slide-out');
        setTimeout(function() {
            lobbie.innerHTML = '';
            lobbie.style.display = 'none';
            lobbie.classList.remove('slide-in');
            lobbie.classList.remove('slide-out');
        }, 1000)
    }
})

document.addEventListener('keyup', (e) => {
    if (e.key == 'Escape') {
        sendNUICB('close');
    }
});

document.getElementById('newLobbie').addEventListener('submit', (e) => {
    e.preventDefault();
    sendNUICB('newData', {
        lobbiename: formInfo.lobbiename.value,
        lobbieid: formInfo.lobbieid.value,
        filename: formInfo.filename.value,
        population: formInfo.population.value,
        lockdown: formInfo.lockdown.value,
        price: formInfo.price.value,
        lobbietype: formInfo.lobbietype.value,
    });
})

function sendNUICB(event, data = {}, cb = () => {}) {
	fetch(`https://${GetParentResourceName()}/${event}`, {
		method: 'POST',
		headers: { 'Content-Type': 'application/json; charset=UTF-8', },
		body: JSON.stringify(data)
	}).then(resp => resp.json()).then(resp => cb(resp));
}