// $(document).ready(function() {$("#playAgainButton").click(startGame)});

$("document").ready(function startGame() {

  var boardArray = new Array(9);
  var winning = [[0,1,2],[3,4,5],[6,7,8],[0,4,8],[2,4,6],[0,3,6],[1,4,7],[2,5,8]];
  var x = "<i class='fa fa-times fa-5x'></i>";
  var o = "<i class='fa fa-circle fa-4x'></i>";
  var xTurn = true;
  var winnerFound = false;
  var player = 0;
  var computer = 0;
  var againstComputer = false;
  var tie = 0;
  var computerEasy = false;
  var computerMedium = false;
  var computerHard = false;
  var boardArray = new Array(9);
  boardArray.fill(0);
  $(".t-menu").toggle();

  $(".col-sm-1").hover(function(){
        $(".level").animate({
            height: 'toggle'
        });
    });

    // Changes difficulty to easy once clicked
  $(".sqComputerLevelEasy").click(function() {
    $(".sqComputer").removeClass();
    $("#computer").addClass('sqComputer greenComputer');
    againstComputer = true;
    computerEasy = true;
    computerMedium = false;
    computerHard = false;
  });
  // Changes difficulty to medium once clicked
  $(".sqComputerLevelMedium").click(function() {
    $(".sqComputer").removeClass();
    $("#computer").addClass('sqComputer orangeComputer');
    againstComputer = true;
    computerEasy = false;
    computerMedium = true;
    computerHard = false;
  });
  // Changes difficulty to hard once clicked
  $(".sqComputerLevelHard").click(function() {
    $(".sqComputer").removeClass();
    $("#computer").addClass('sqComputer redComputer');
    againstComputer = true;
    computerEasy = false;
    computerMedium = false;
    computerHard = true;
  });
  // Changes back to two player mode
  $(".sqPlayer").click(function() {
    $(".sqComputer").removeClass();
    $("#computer").addClass('sqComputer blackComputer');
    againstComputer = false;
  });

    $(".gameCell").click(takeTurns);


  // Determines whose turn it is and allows the users to place and X or O on the board. If it is against the computer then it goes after x has gone.
  function takeTurns() {
    var boardPos = ($(this).parent().index() * 3) + $(this).index();

    if(xTurn && boardArray[boardPos] === 0 && !winnerFound ) {
      $(this).children('.divCell').html(x);
      boardArray[boardPos] = 1;
      xTurn = false;
      processWinner();
      if(againstComputer && !winnerFound) {
        setTimeout(function() {computerTurn(boardPos)}, 1000);
      }
    } else if (boardArray[boardPos] === 0 && !winnerFound && !againstComputer){
      $(this).children('.divCell').html(o);
      boardArray[boardPos] = -1;
      xTurn = true;
      processWinner();
    }

    if (boardArray.indexOf(0) === -1 && !winnerFound) {
      processWinner();
      tie++;
      $("#tiescore").text(tie);
      $(".displayMessage").text("Board is full. It was a tie!")
      $(".t-menu").toggle();

    }
  }

  // Is called when it is the computer's turn to go and picks a random number(index) on the baord that is not currently used.
  function computerTurn(boardPos) {
    var easyTurnIndex = Math.floor(Math.random()*boardArray.length);
    var medTurnIndex;
    var hardTurnIndex;
    var i = 1;
    var medPosFound = false;

    if (computerMedium === true) {
      do {
        if(boardArray[boardPos+i] === 0) {
          medTurnIndex = boardPos + i;
          medPosFound = true;
          alert("Position+ at " + medTurnIndex);
        } else if (boardArray[boardPos-i] === 0) {
          medTurnIndex = boardPos - i;
          medPosFound = true;
          alert("Position- at " + medTurnIndex);
        }
        i++;
      } while (!medPosFound)
    }

    var hardMoveFound = false;
    if (computerHard === true) {
      for (var i = 0; i < 8; i++) {
        var a = boardArray[winning[i][0]];
        var b = boardArray[winning[i][1]];
        var c = boardArray[winning[i][2]];

        if((a+b+c) === 2) {
          if(a === 0) {
          hardTurnIndex = winning[i][0];
          hardMoveFound = true;
        } else if(b === 0) {
          hardTurnIndex = winning[i][1];
          hardMoveFound = true;
        } else if(c === 0) {
          hardTurnIndex = winning[i][2];
          hardMoveFound = true;
        }
        }
      }
    }
    if(!hardMoveFound && computerHard === true) {
      hardTurnIndex = Math.floor(Math.random()*boardArray.length);
      hardMoveFound = false;
    }

    if ((boardArray[easyTurnIndex] === 0) && (computerEasy === true)) {
      $(".gameCell").eq(easyTurnIndex).html(o).fadeIn(2000);
      boardArray[easyTurnIndex] = -1;
      xTurn = true;
      processWinner();
    } else if ((boardArray[medTurnIndex] === 0) && (computerMedium === true)) {
      $(".gameCell").eq(medTurnIndex).html(o).fadeIn(2000);
      boardArray[medTurnIndex] = -1;
      xTurn = true;
      processWinner();
    } else if(computerHard ===true) {

      $(".gameCell").eq(hardTurnIndex).html(o).fadeIn(2000);
      boardArray[hardTurnIndex] = -1;
      xTurn = true;
      processWinner();
    } else {
      computerTurn();
    }
  };

  // Resets the baord so users can play again
  function boardReset() {
    boardArray.fill(0);
    xTurn = true;
    winnerFound = false;
    $(".divCell").html("");
    $(".t-menu").toggle();
  };

  // Runs after every move and checks to make sure that no one has won.
  function processWinner() {
    var checkXO;
    var winner;
    var winnerSpot;
    for (var i = 0; i < 8; i++) {
          if(((((boardArray[winning[i][0]] + boardArray[winning[i][2]]) + boardArray[winning[i][1]]) === 3) || ((boardArray[winning[i][0]] + boardArray[winning[i][2]]) + boardArray[winning[i][1]]) === -3) &&
          (boardArray[winning[i][0]] != 0)) {

          winner = true;
          $(".t-menu").fadeIn(1500);
          switch (boardArray[winning[i][0]]) {
            case 1:
              player++;
              $(".displayMessage").text("X won!");
              $("#xscore").text(player)
              break;
            default:
              computer++;
              $(".displayMessage").text("O won!");
              $("#oscore").text(computer)
          }

          winnerFound = true;
          break;
        }
    }
  }
  $("#playAgainButton").click(boardReset);
});
