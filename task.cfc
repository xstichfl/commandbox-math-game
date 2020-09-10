/**
* A fun flash card addition game written as a Commandbox task runner.

* To run, use command "task run".
* By default there are 10 questions per game. This can be changed using "task run :numQuestions=5".
* By default the game starts easy, adding numbers up to 10. Change the difficulty using "task run :highNumber=20".
* If you choose to play again, the difficulty will be increased based on how well you played.
*/

component accessors="true" {

	property name="name" type="string" default="";
	property name="score" type="numeric" default=0;
	property name="numQuestions" type="numeric" default=0;
	property name="highNumber" type="numeric" default=0;

	public function run(numeric numQuestions = 10, numeric highNumber = 10) {

		setNumQuestions(arguments.numQuestions);
		setHighNumber(arguments.highNumber);
		
		shell.clearScreen();
		print.maroonOnWhiteLine("Let's Play the Addition Game!");
		setName( ask("What is your name? ") );
		print.line("Thanks for playing, " & getName() & "!");
		print.line("Press any key to start").toConsole();
		waitForKey();
		playGame();
		print.line("Thanks for playing, hope to see you again soon.");
	}

	private void function playGame() {
		setScore(0);
		for (local.questionNumber = 1; local.questionNumber <= getNumQuestions(); local.questionNumber++) {
			askQuestion(local.questionNumber);
			showScore();
			if (local.questionNumber < getNumQuestions()) {
				print.line("Press any key for the next question").toConsole();
				waitForKey();
			}
		}
		local.increase = evaluateScore();
		if (confirm("Do you want to play again?")) {
			setHighNumber(getHighNumber()+local.increase);
			playGame();
		}
	}

	private void function askQuestion(required numeric questionNumber) {
		local.numbers = [randRange(1, getHighNumber()), randRange(1, getHighNumber())];
		local.answer = local.numbers.sum();
		local.response = "";

		shell.clearScreen();
		print
			.line("Question ##" & arguments.questionNumber)	
			.line(getLargeText(local.numbers[1] & " + " & local.numbers[2] & " ="));

		while (!isNumeric(local.response)) {
			local.response = ask("Answer: ");
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
		print
			.aquaLine("Your score is")
			.aquaLine(getLargeText(getScore()));
	}

	private numeric function evaluateScore() {
		local.maxScore = getNumQuestions() * 10;
		local.percentCorrect = (getScore() / local.maxScore) * 100;
		if (local.percentCorrect >= 90) {
			print.greenLine("Excellent, you got " & numberFormat(local.percentCorrect) & "% of the questions right! You're a math wiz!");
			return 10;
		} else if (local.percentCorrect >= 70) {
			print.yellowLine("Nice job, you got " & numberFormat(local.percentCorrect) & "% of the questions right.");
			return 5;
		} else if (local.percentCorrect >= 40) {
			print.yellowLine("You got " & numberFormat(local.percentCorrect) & "% of the questions right. With some more practice you'll master this.");
			return 0;
		} else {
			print.redLine("You got " & numberFormat(local.percentCorrect) & "% of the questions right. Keep practicing, I know you can do this!");
			return 0;
		}
	}

	private string function getLargeText(required string text) {
		try {
			cfhttp(url="http://artii.herokuapp.com/make") {
				cfhttpparam (type="url", name="text", value=arguments.text);
			}
			local.text = cfhttp.fileContent
		} catch (any e) {
			// Fall back to normal text if web service is not available
			local.text = arguments.text;
		}
		return local.text;
	}

}
