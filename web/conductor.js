var sampler;
function loadSampler() {
    sampler = new Tone.Sampler({
        urls: {
            "C4": "C4.mp3",
            "D#4": "Ds4.mp3",
            "F#4": "Fs4.mp3",
            "A4": "A4.mp3",
        },
        release: 1,
        baseUrl: "https://tonejs.github.io/audio/salamander/",
    }).toDestination();

}

function playNote(json) {
    var action = JSON.parse(json)
    var notes = action['notes'];
    var duration = action['duration'];

    sampler.triggerAttackRelease(notes, duration);
    Tone.Draw.schedule(() => {
        window.triggerNoteEvent(json);
    });
}

function playSequencer(json) {

    // const osc = new Tone.Oscillator().toDestination();
    // Tone.Transport.bpm.value = 80;
    // // start/stop the oscillator every quarter note
    // Tone.Transport.scheduleRepeat(time => {
    //     sampler.triggerAttackRelease('C3', '32n')
    // }, "16n");
    // Tone.Transport.start();
    // ramp the bpm to 120 over 10 seconds
    // Tone.Transport.bpm.rampTo(120, 3);

    var attackRelease = JSON.parse(json)
    const now = Tone.now()
    var counter = 0;
    for (var i = 0; i < attackRelease.length; i++) {
        var action = attackRelease[i];

        var notes = action['notes'];
        var duration = action['duration'];
        var position = action['position'];

        sampler.triggerAttackRelease(notes, duration, now + position, 0.5);
        Tone.Draw.schedule(() => {
            window.triggerNoteEvent(JSON.stringify(attackRelease[counter]))
            counter++;
        }, now + position);
    }
}

window.logger = (flutter_value) => {
    console.log({ js_context: this, flutter_value });
}