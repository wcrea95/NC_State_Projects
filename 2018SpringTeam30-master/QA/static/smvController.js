var app = angular.module("smvApp", []);
 
 app.config(function($interpolateProvider) {
    $interpolateProvider.startSymbol('~{');
    $interpolateProvider.endSymbol('}~');
  });
app.controller('smvController', 
	function($scope, $http) {
	
	$scope.range = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
	$scope.numResults = 2;
	$scope.haveResults = false;
	$scope.debug = false;
	$scope.default_method = 'spacy_synset_average';
	$scope.selectedQuestions = 2;

	$http.get('/api/questions').then(
		function(response){
			$scope.questionSets = angular.fromJson(response.data);

		});

	$scope.askQuestion = function(question_set, question, debug, results) {
		
		$scope.haveResults = false;

		var requestData  = new Object();
		requestData.question_set = question_set;
		requestData.question = question;

		if(!debug){
			requestData.default = $scope.default_method;
		}

		requestData.debug = debug;
		requestData.results = results;
		console.log(requestData);
		$http.post("/api/ask", requestData).then(
			function(response){
				$scope.result = response.data;
				console.log($scope.result);
				$scope.haveResults = true;
				},
			function(response){
				$scope.haveResults = false;
			});
		
	}



    
});