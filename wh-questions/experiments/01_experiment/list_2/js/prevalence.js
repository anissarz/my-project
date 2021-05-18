function make_slides(f) {
  var slides = {};

  slides.bot = slide({
    name: "bot",
    start: function () {
      $('.err1').hide();
      $('.err2').hide();
      $('.disq').hide();
      exp.speaker = _.shuffle(["James", "John", "Robert", "Michael", "William", "David", "Richard", "Joseph", "Thomas", "Charles"])[0];
      exp.listener = _.shuffle(["Mary", "Patricia", "Jennifer", "Linda", "Elizabeth", "Barbara", "Susan", "Jessica", "Sarah", "Margaret"])[0];
      exp.lives = 0;
      var story = exp.speaker + ' says to ' + exp.listener + ': "It\'s a beautiful day, isn\'t it?"'
      var question = 'Who does ' + exp.speaker + ' talk to?';
      document.getElementById("s").innerHTML = story;
      document.getElementById("q").innerHTML = question;
    },
    button: function () {
      exp.text_input = document.getElementById("text_box").value;
      var lower = exp.listener.toLowerCase();
      var upper = exp.listener.toUpperCase();

      if ((exp.lives < 3) && ((exp.text_input == exp.listener) | (exp.text_input == lower) | (exp.text_input == upper))) {
        exp.data_trials.push({
          "slide_number_in_experiment": exp.phase,
          "tgrep_id": "bot_check",
          "response": [exp.text_input, exp.listener],
        });
        exp.go();
      }
      else {
        exp.data_trials.push({
          "slide_number_in_experiment": exp.phase,
          "tgrep_id": "bot_check",
          "response": [exp.text_input, exp.listener],
        });
        if (exp.lives == 0) {
          $('.err1').show();
        } if (exp.lives == 1) {
          $('.err1').hide();
          $('.err2').show();
        } if (exp.lives == 2) {
          $('.err2').hide();
          $('.disq').show();
          $('.button').hide();
        }
        exp.lives++;
      }
    },
  });

  slides.i0 = slide({
    name: "i0",
    start: function () {
      $("#n_trials").html(exp.n_trials);
      exp.startT = Date.now();
    }
  });

  slides.instructions_slider = slide({
    name: "instructions_slider",
    start: function () {
      $("#instrunctionGen").html('<table class=table1 id="instructionGen"> </table>');
      var dispRow = $(document.createElement('tr')).attr("id", 'rowp' + 1);
      dispRow.append("<div class=row>");
      dispRow.append("<div align=center><button class=continueButton onclick= _s.button()>Continue</button></div>");
      dispRow.append('<td/>');
      dispRow.append('</div>');
      dispRow.appendTo("#instructionGen");

    },
    button: function () {
      exp.go(); //use exp.go() if and only if there is no "present" data.
    },
  });


// 
  slides.example1 = slide({
    name: "example1",

    start: function () {
      // hide error message 
      $(".err").hide();

    },
    
    // this is executed when the participant clicks the "Continue button"
    button: function() {
      // read in the value of the selected radio button
      this.radio = $("input[name='number']:checked").val();


      // check whether the participant selected a reasonable value (i.e, 5, 6, or 7)
      if (this.radio == "5" || this.radio == "6" || this.radio == "7") {
        // log response
        this.log_responses();
        // continue to next slide
        exp.go();
      } else {
        // participant gave non-reasonable response --> show error message
        $('.err').show();
        this.log_responses();
      }
    },


    // handle click on "Continue" button no correction
    // button: function() {
    //   this.radio = $("input[name='number']:checked").val();
    //   this.strange = $("#check-strange:checked").val() === undefined ? 0 : 1;
    //   if (this.radio) {
    //     this.log_responses();
    //     exp.go(); //use exp.go() if and only if there is no "present"ed data, ie no list of stimuli.
    //     // _stream.apply(this); //use _stream.apply(this) if there is a list of "present" stimuli to rotate through
    //   } else {
    //     $('.err').show();
    //   }
    // },

    // save response
    log_responses: function() {
      exp.data_trials.push({
        "tgrep_id": "example1",
        "slide_number_in_experiment": exp.phase, //exp.phase is a built-in trial number tracker
        "response": this.radio,
        "strangeSentence": this.strange,
        "sentence": "",
      });
    } // end log responses
  }); //end slide example 1

  slides.example2 = slide({
    name: "example2",

    start: function () {
      // hide error message 
      $(".err").hide();
    },
    
    // this is executed when the participant clicks the "Continue button"
    button: function() {
      // read in the value of the selected radio button
      this.radio = $("input[name='number']:checked").val();
      // check whether the participant selected a reasonable value (i.e, 5, 6, or 7)
      if (this.radio == "1" || this.radio == "2" || this.radio == "3") {
        // log response
        this.log_responses();
        // continue to next slide
        exp.go();
      } else {
        // participant gave non-reasonable response --> show error message
        $('.err').show();
        this.log_responses();
      }
    },


    // handle click on "Continue" button no correction
    // button: function() {
    //   this.radio = $("input[name='number']:checked").val();
    //   this.strange = $("#check-strange:checked").val() === undefined ? 0 : 1;
    //   if (this.radio) {
    //     this.log_responses();
    //     exp.go(); //use exp.go() if and only if there is no "present"ed data, ie no list of stimuli.
    //     // _stream.apply(this); //use _stream.apply(this) if there is a list of "present" stimuli to rotate through
    //   } else {
    //     $('.err').show();
    //   }
    // },

    // save response
    log_responses: function() {
      exp.data_trials.push({
        "tgrep_id": "example2",
        "slide_number_in_experiment": exp.phase, //exp.phase is a built-in trial number tracker
        "response": this.radio,
        "strangeSentence": this.strange,
        "sentence": "",
      });
    } // end log responses
  }); //end slide example 2


  slides.startExp = slide({
    name: "startExp",
    start: function () {
      $("#instrunctionGen").html('<table class=table1 id="instructionGen"> </table>');
      var dispRow = $(document.createElement('tr')).attr("id", 'rowp' + 1);
      dispRow.append("<div class=row>");
      dispRow.append("<div align=center><button class=continueButton onclick= _s.button()>Continue</button></div>");
      dispRow.append('<td/>');
      dispRow.append('</div>');
      dispRow.appendTo("#instructionGen");

    },
    button: function () {
      exp.go(); //use exp.go() if and only if there is no "present" data.
    },
  });

  // test items
  slides.generateEntities = slide({
    name: "generateEntities",
    present: exp.stimuli, // This the array generated from stimuli.js
    present_handle: function (stim) { // this function is called bascially on exp.stim (more or less)
      $(".err").hide();
      $("#check-strange").prop("checked", false);

      var generic = stim;
      this.generic = generic;

      var contexthtml = this.format_context(generic.PreceedingContext);
      var entirehtml = "<font color=#FF0000> " + this.format_sentence(generic.EntireSentence) + "<br>"

      contexthtml = contexthtml + entirehtml


      $(".context").html(contexthtml)
      // $(".context").html(shouldhtml)
      // $(".context").html(shouldhtml)
      $("input[name='number']:checked").prop("checked", false);
      $("#check-strange").prop("checked", false);
      document.getElementById("could").innerHTML = this.generic.CouldParaphrase
      document.getElementById("should").innerHTML = this.generic.ShouldParaphrase
    },


    // speakers 1 and 2 
    format_context: function (context) {
      // remove all ### standing alone
      contexthtml = context.replace(/###/g, " ");

      contexthtml = contexthtml.replace(/\sspeakera(\d+).\sspeakerb(\d+)./g, " ")
      contexthtml = contexthtml.replace(/\sspeakerb(\d+).\sspeakera(\d+)./g, " ")
      // replace first three ## with Speaker 1
      contexthtml = contexthtml.replace(/speakera(\d+)./g, "<br><b>Speaker #1: </b>");
      contexthtml = contexthtml.replace(/speakerb(\d+)./g, "<br><b>Speaker #2: </b>");
      contexthtml = contexthtml.replace(/speakera./g, "<br><b>Speaker #1: </b>");
      contexthtml = contexthtml.replace(/speakerb./g, "<br><b>Speaker #2: </b>");
      
      //remove *exp*
      contexthtml = contexthtml.replace(/\*exp/g, "");
      // remove traces 
      contexthtml = contexthtml.replace(/\s\*t*\**\-\d*/g, "");
            //remove ?
      contexthtml = contexthtml.replace(/\s\*\?\*/g, "");
      // remove random asterisks

      contexthtml = contexthtml.replace(/\*ich\*\-\d/g, "");

      contexthtml = contexthtml.replace(/\*/g, "");
      // remove the random 0
      contexthtml = contexthtml.replace(/0/g, "");
      //remove the ""
      contexthtml = contexthtml.replace(/\"/g, "");
      //trying to remove weird spaces
      contexthtml = contexthtml.replace(/\s{2,}/g," ");



      // this just deals with the first instance of speaker
      if (!contexthtml.startsWith(" <br><b>Speaker #")) {
        var ssi = contexthtml.indexOf("Speaker #");
        switch (contexthtml[ssi + "Speaker #".length]) {
          case "1":
            contexthtml = "<br><b>Speaker #2:</b> " + contexthtml;
            break;
          case "2":
            contexthtml = "<br><b>Speaker #1:</b> " + contexthtml;
            break;
          default:
            break;
        }
      };
      return contexthtml;
    },



    format_sentence: function (sentence) {
      // remove the traces and the following whitespace
      entirehtml = sentence.replace(/\s\*t*\**\-\d*/g, "");
      // entirehtml = sentence.replace(/\-\d+/g, "");
      entirehtml = entirehtml.replace(/\*ich\*\-\d/g, "");
      entirehtml = entirehtml.replace(/0/g, "");
      entirehtml = entirehtml.replace(/\*exp\*\-\d/g, "");
      entirehtml = entirehtml.replace(/\*/g, "");
      entirehtml = entirehtml.replace(/\"/g, "");
      entirehtml = entirehtml.replace(/\s+/g," ");
      return entirehtml
    },

    // handle click on "Continue" button
    button: function() {
      this.radio = $("input[name='number']:checked").val();
      this.strange = $("#check-strange:checked").val() === undefined ? 0 : 1;
      if (this.radio) {
        this.log_responses();
        _stream.apply(this) //use exp.go() if and only if there is no "present"ed data, ie no list of stimuli.
        // _stream.apply(this); //use _stream.apply(this) if there is a list of "present" stimuli to rotate through
      } else {
        $('.err').show();
      }
    },

    // save response
    log_responses: function() {
      exp.data_trials.push({
        "tgrep_id": this.generic.TGrepID,
        // "sentence": this.stim.ButNotAllSentence,
        "slide_number_in_experiment": exp.phase, //exp.phase is a built-in trial number tracker
        "response": this.radio,
        "strangeSentence": this.strange
      });
    }
  });


  slides.subj_info = slide({
    name: "subj_info",
    submit: function (e) {
      //ifFdata (e.preventDefault) e.preventDefault(); // I don't know what this means.
      exp.subj_data = _.extend({
        language: $("#language").val(),
        enjoyment: $("#enjoyment").val(),
        asses: $('input[name="assess"]:checked').val(),
        age: $("#age").val(),
        gender: $("#gender").val(),
        education: $("#education").val(),
        problems: $("#problems").val(),
        fairprice: $("#fairprice").val(),
        comments: $("#comments").val(),
        // paraArray: [exp.paraphraseArray[0].name, exp.paraphraseArray[1].name, exp.paraphraseArray[2].name, exp.paraphraseArray[3].name]
      });
      exp.go(); //use exp.go() if and only if there is no "present" data.
    }
  });

  slides.thanks = slide({
    name: "thanks",
    start: function () {
      exp.data = {
        "trials": exp.data_trials,
        "catch_trials": exp.catch_trials,
        "system": exp.system,
        "condition": exp.condition,
        "subject_information": exp.subj_data,
        "time_in_minutes": (Date.now() - exp.startT) / 60000
      };
      setTimeout(function () { proliferate.submit(exp.data); }, 1000);
    }
  });

  return slides;
}

/// init ///
function init() {

  repeatWorker = false;
  //exp.n_entities = 1;
  exp.names = [];
  exp.all_names = [];
  exp.trials = [];
  exp.catch_trials = [];
  var stimuli = generate_stim(); // this calls a function in stimuli.js
  // exp.theParaphrase = { name: "the" };
  // exp.aParaphrase = { name: "a" };
  // exp.allParaphrase = { name: "all" };
  // exp.paraphraseArray = _.shuffle([exp.theParaphrase, exp.aParaphrase, exp.allParaphrase]);
  // console.log("paraarray: " + exp.paraphraseArray[1].value);
  console.log(stimuli.length);
  //exp.stimuli = _.shuffle(stimuli).slice(0, 15);
  exp.stimuli = stimuli.slice();
  exp.stimuli = _.shuffle(exp.stimuli);
  exp.n_trials = exp.stimuli.length;
  exp.stimcounter = 0;

  exp.stimscopy = exp.stimuli.slice();

  exp.system = {
    Browser: BrowserDetect.browser,
    OS: BrowserDetect.OS,
    screenH: screen.height,
    screenUH: exp.height,
    screenW: screen.width,
    screenUW: exp.width
  };
  //blocks of the experiment:
  exp.structure = [
    "bot",
    "i0",
    "instructions_slider",
    "example1",
    "example2",
    "startExp",
    "generateEntities",// This is where the test trials come in.
    "subj_info",
    "thanks"
  ];

  exp.data_trials = [];
  //make corresponding slides:
  exp.slides = make_slides(exp);

  exp.nQs = utils.get_exp_length(); //this does not work if there are stacks of stims (but does work for an experiment with this structure)
  //relies on structure and slides being defined

  $('.slide').hide(); //hide everything

  //make sure turkers have accepted HIT (or you're not in mturk)
  $("#start_button").click(function () {
    if (turk.previewMode) {
      $("#mustaccept").show();
    } else {
      $("#start_button").click(function () { $("#mustaccept").show(); });
      exp.go();
    }
  });

  exp.go(); //show first slide
}

