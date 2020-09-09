/**
* Description of task
*/
component accessors="true" {

	property name="name" type="string" default="";
	property name="score" type="numeric" default=0;
	property name="numQuestions" type="numeric" default=0;

	/**
	* 
	*/
	public function run(numeric numQuestions = 10) {

		setNumQuestions(arguments.numQuestions);
		
		print.maroonOnWhiteLine("Let's Play the Addition Game!");
		setName( ask("What is your name? ") );
		print.line("Thanks for playing, " & getName() & "!");
		print.line("Press any key to start").toConsole();
		waitForKey();
		for (local.questionNumber = 1; local.questionNumber <= getNumQuestions(); local.questionNumber++) {
			askQuestion();
			showScore();
			if (local.questionNumber < getNumQuestions()) {
				print.line("Press any key for the next question").toConsole();
				waitForKey();
			} else {
				print.line("Thanks for playing");
			}
		}
	}

	private void function askQuestion() {
		local.numbers = [randRange(0, 10), randRange(0, 10)];
		local.answer = local.numbers.sum();
		local.response = "";
		while (!isNumeric(local.response)) {
			local.response = ask("What is " & local.numbers[1] & " + " & local.numbers[2] & "? ");
			if (!isNumeric(local.response)) {
				print.yellowLine("Sorry, that is not a number. Try again.");
			}
		}
		if (local.response == local.answer) {
			print.greenLine("Correct!");
			setScore(getScore() + 10);
		} else {
			print.redLine("Sorry, that's not right. The answer is " & local.answer & ".");
		}
	}

	private void function showScore() {
		print.aquaLine("Your score is " & getScore());
	}

}
