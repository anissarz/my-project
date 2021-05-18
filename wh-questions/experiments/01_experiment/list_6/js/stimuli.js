
var path = 'https://raw.githubusercontent.com/anissarz/my-project/master/wh-questions/experiments/clean_corpus/01_experiment/corpus_6.txt'
console.log(path);
 
function get_data(fullpath) {
    var response = $.ajax({
        type: "GET",
        async: false,
        url: fullpath,
        dataType: "text",
    });
    return response.responseText;
}
 
function generate_stim() {
   
    var contents = get_data(path);
    var raw = contents;
        var rows = raw.split('\n');
 
        var data = [];
        headings = rows[0].trim().split('\t'); // need to trim when adding column headings from excel
        console.log(headings)
        var total = rows.length;

        // Push every item from the text file into the array, split on the tab (or whatever split)
        for (var i = 1; i < total; i++) {		
                data.push(rows[i].split('\t'));
            } 

        console.log("data: ",data);
 
        var stim = data.map(function(row) {
            return row.reduce(function(result, field, index) {
                result[headings[index]] = field;
                return result;
            }, {});
        });

        console.log("stim: ",stim);
   
    return stim;
}
 