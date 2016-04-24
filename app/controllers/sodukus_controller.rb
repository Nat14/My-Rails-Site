class SodukusController < ApplicationController
  def view

  end

  def load_soduku_board
    @soduku =
        [[0, 6, 0, 1, 0, 4, 0, 5, 0],
        [0, 0, 8, 3, 0, 5, 6, 0, 0],
        [2, 0, 0, 0, 0, 0, 0, 0, 1],
        [8, 0, 0, 4, 0, 7, 0, 0, 6],
        [0, 0, 6, 0, 0, 0, 3, 0, 0],
        [7, 0, 0, 9, 0, 1, 0, 0, 4],
        [5, 0, 0, 0, 0, 0, 0, 0, 2],
        [0, 0, 7, 2, 0, 6, 9, 0, 0],
        [0, 4, 0, 5, 0, 8, 0, 7, 0]]
    render 'view'
  end

  def soduku_solver
    soduku = []
    columns = []
    squares = []
    poss = []

    # read from question file
    # def read_board(soduku)
    #   lines = File.readlines("game-1.txt")
    #   (1..11).each do |i|
    #     next if lines[i][0] == "+"
    #     x = lines[i].chomp.gsub("_", "0").delete "|"
    #     soduku << x.split(" ").map(&:to_i)
    #   end
    # end

    # create array of columns
    def createColumn(aColumn, aSoduku)
      (0..8).each do |row|
        aColumn[row] = aSoduku.map { |x| x[row] }
      end
    end

    # create array of square
    def createSquare(aSquare, aSoduku)
      newRow = 0
      (0..8).each do |x| aSquare[x] = [] end
      (0..2).each do |row|
        (0..2).each do |col|
          (0..2).each do |dataRow|
            (0..2).each do |dataColumn|
              aSquare[newRow].push(aSoduku[dataRow+(row*3)][dataColumn+(col*3)])
            end
          end
          newRow += 1
        end
      end
    end

    # number not found in row, column, or square then return that number to add into possibilities array
    def addPoss (aSoduku, aColumn, aSquare, row, col, sq, i)
      if !(aSoduku[row].include?(i)) & !(aColumn[col].include?(i)) & !(aSquare[sq].include?(i))
        return i
      end
    end

    # craete array of possibilities
    def possibilities(aPoss, aSoduku, aColumn, aSquare)
      possNum = 0
      sqNum = 0
      (0..8).each do |row|
        aPoss[row] = []
        (0..8).each do |column|
          aPoss[row][column] = []
          if aSoduku[row][column] == 0
            (1..9).each do |x|
              sqNum = (row/3)*3 + (column/3)
              possNum = addPoss(aSoduku, aColumn, aSquare, row, column, sqNum, x)
              aPoss[row][column] << possNum unless possNum.nil?
            end
          end
        end
      end
    end

    # print out the board
    def printSoduku(arr)
      (0..8).each do |x| print arr[x],"\n" end
    end

    # fill in number to soduku
    def fillNumbers(aPoss, aSoduku)
      (0..8).each do |row|
        (0..8).each do |column|
          if (aSoduku[row][column] == 0) & (aPoss[row][column].length == 1)
             aSoduku[row][column] = aPoss[row][column][0]
             puts "fill in #{aPoss[row][column][0]}"
           end
        end
      end
    end

    def runningSolver(aSoduku, aColumn, aSquare, aPoss, aSave)
      sodukuBefore = ""
      while (aSoduku.to_s.include?("0")) & (sodukuBefore != aSoduku.to_s)
        createColumn(aColumn, aSoduku)
        createSquare(aSquare, aSoduku)
        possibilities(aPoss, aSoduku, aColumn, aSquare)
        sodukuBefore = aSoduku.to_s
        fillNumbers(aPoss, aSoduku)
      end
    end

    def addTotal(arr)
      total = 0
      (0..8).each do |i|
        total = total + arr[i].inject() { |sum, n| sum + n }
      end
      return total
    end

    read_board(soduku)
    saveSoduku = []
    puts "---Original----"
    printSoduku(soduku)
    runningSolver(soduku, columns, squares, poss, saveSoduku)
    puts "--After fill in all possibilities--"
    printSoduku(soduku)
    saveSoduku = Marshal.load( Marshal.dump(soduku) )
    savePoss = Marshal.load( Marshal.dump(poss) )
    numberToTry = []
    totalNumber = 0

    (0..8).each do |possRow|
      (0..8).each do |possCol|
        if poss[possRow][possCol] != []
          numberToTry = poss[possRow][possCol]
          (0..numberToTry.length).each do |number|
            soduku[possRow][possCol] = numberToTry[number]
            puts "trying number #{numberToTry[number]}"
            runningSolver(soduku, columns, squares, poss, saveSoduku)
            puts addTotal(soduku)
            totalNumber = addTotal(soduku)
            break if totalNumber == 405
            soduku = Marshal.load( Marshal.dump(saveSoduku) )
          end
        end
      end
    end
    puts "--Result--"
    printSoduku(soduku)
    puts "--END--"
  end
end
