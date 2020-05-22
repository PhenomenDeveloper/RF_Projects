import Foundation

// MARK: - Enum
enum Way: Int {
    case up = 0
    case right = 1
    case bottom = 2
    case left = 3
}

enum Actor: String {
    case space = "🌫"
    case apple = "🍎"
    case snakeHead = "😃", snakeBodyWithApple = "●", snakeBody = "◦", snakeTail = "・"
}

// MARK: - Protocols
protocol Location {
    var row: Int { get set }
    var column: Int { get set }
}

protocol Loop {
    func tick()
}

protocol Snake: Loop {
    var length: Int { get }
    var body: [Point] { get }
}

protocol Food: Location {
    var location: Location { get }
}

protocol AppleField {
    func hasApple(direction: Location) -> Bool
}

protocol Crawling {
    var body: [Location] { get set }
    
    typealias NewLocation = Location
    // может двигаться если в заданном направлении есть куда двигаться, нет хваста нет границы
    func move(direction: Way) throws -> NewLocation
}

protocol Engine: Loop {
    typealias Result = Void
    var log: [Location] { get }
    func run(completion: (Result) -> Void)
}

protocol Field {
    var rows: Int { get set }
    var columns: Int { get set }
    var matrix: [Int] { get set }
}

public struct SomeField: Field {
    
    public var rows: Int
    public var columns: Int
    
    public var matrix: [Int]
    
    public init() {
        var instance: [Int] = []
        
        //           A  B  C  D  E  F  G  H  I  J  K  L  M  O  P  Q  R  S  T
        instance += [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1] // 1
        instance += [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1] // 2
        instance += [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1] // 3
        instance += [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1] // 4
        instance += [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1] // 5
        instance += [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1] // 6
        instance += [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1] // 7
        instance += [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1] // 8
        instance += [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1] // 9
        instance += [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1] // 10
        instance += [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1] // 11
        
        rows     = 11
        columns  = instance.count / rows
        
        matrix = instance
        
    }
}

// MARK: - Структура точки лабиринта
public struct Point: Location, Equatable {
    var row: Int {
        get {
            return i
        }
        
        set {
            i = newValue
        }
    }
    var column: Int {
        get {
            return j
        }
        
        set {
            j = newValue
        }
    }
    
    private var i: Int
    private var j: Int
    
    public init(i: Int, j: Int) {
        self.i = i
        self.j = j
    }
    // MARK: - Функция перевода из [i,j] в Location
    static func transformLocation(row: Int, column: Int) -> Int {
        return row * field.columns + column
    }
    
    
}

// MARK: - Структура игрока
struct SnakePlayer: Snake {
    var length: Int = 2
    
    var point: Point = Point(i: 5, j: 5)
    var body: [Point] = [Point(i: 5, j: 5),
                         Point(i: 5, j: 6)]
    var way: Way = .up
    
    func tick() {
        fatalError()
    }
    
}

// MARK: - Функция поворота и движения
func turnAndMove(snakePlayer: inout SnakePlayer, wayValue: Int, apple: inout Point, needGo: inout Bool) {
    
    guard needGo else { return }
    needGo = false
    
    let number = (snakePlayer.way.rawValue + wayValue) % 4
    guard let way = Way.init(rawValue: number) else { return }
    snakePlayer.way = way
    
    let tempLast = snakePlayer.body.last!
    
    var temp = Point.transformLocation(row: snakePlayer.body.last!.row, column: snakePlayer.body.last!.column)
    field.matrix[temp] = 0
    
    for i in 1..<snakePlayer.body.count {
        let currentIndex = snakePlayer.body.count - i
        let previousIndex = currentIndex - 1
        snakePlayer.body[currentIndex] = snakePlayer.body[previousIndex]
        let temp = Point.transformLocation(row: snakePlayer.body[currentIndex].row, column: snakePlayer.body[currentIndex].column)
        field.matrix[temp] = 1
    }
    // = сдвиг головы
    switch snakePlayer.way {
    case .up:
        snakePlayer.point.row -= 1
    case .left:
        snakePlayer.point.column -= 1
    case .right:
        snakePlayer.point.column += 1
    case .bottom:
        snakePlayer.point.row += 1
    }
    
    temp = Point.transformLocation(row: snakePlayer.point.row, column: snakePlayer.point.column)
    field.matrix[temp] = 1
    
    snakePlayer.body[0] = snakePlayer.point
    
    if snakePlayer.point == apple {
        snakePlayer.body.append(tempLast)
        snakePlayer.length += 1
        apple = randomApplePoint(location: snakePlayer.body)
    }
    
}

// MARK: - Функции проверки разных сторон
func frontWayIsFree(matrix: [Int], snakePlayer: SnakePlayer) -> Bool {
    let value: Int
    switch snakePlayer.way {
    case .up:
        value = matrix[Point.transformLocation(row: snakePlayer.point.row - 1, column: snakePlayer.point.column)]
    case .left:
        value = matrix[Point.transformLocation(row: snakePlayer.point.row, column: snakePlayer.point.column - 1)]
    case .bottom:
        value = matrix[Point.transformLocation(row: snakePlayer.point.row + 1, column: snakePlayer.point.column)]
    case .right:
        value = matrix[Point.transformLocation(row: snakePlayer.point.row, column: snakePlayer.point.column + 1)]
    }
    return value == 0
    
}

func leftWayIsFree(matrix: [Int], snakePlayer: SnakePlayer) -> Bool {
    let value: Int
    switch snakePlayer.way {
    case .up:
        value = matrix[Point.transformLocation(row: snakePlayer.point.row, column: snakePlayer.point.column - 1)]
    case .left:
        value = matrix[Point.transformLocation(row: snakePlayer.point.row + 1, column: snakePlayer.point.column)]
    case .bottom:
        value = matrix[Point.transformLocation(row: snakePlayer.point.row, column: snakePlayer.point.column + 1)]
    case .right:
        value = matrix[Point.transformLocation(row: snakePlayer.point.row - 1, column: snakePlayer.point.column)]
    }
    return value == 0
    
}

func rightWayIsFree(matrix: [Int], snakePlayer: SnakePlayer) -> Bool {
    let value: Int
    switch snakePlayer.way {
    case .up:
        value = matrix[Point.transformLocation(row: snakePlayer.point.row, column: snakePlayer.point.column + 1)]
    case .left:
        value = matrix[Point.transformLocation(row: snakePlayer.point.row - 1, column: snakePlayer.point.column)]
    case .bottom:
        value = matrix[Point.transformLocation(row: snakePlayer.point.row, column: snakePlayer.point.column - 1)]
    case .right:
        value = matrix[Point.transformLocation(row: snakePlayer.point.row + 1, column: snakePlayer.point.column)]
    }
    return value == 0
    
}

// MARK: - Функция печати игрового
func printEmojiField(snakePlayer: SnakePlayer, apple: Point) {
    let playerPoint = snakePlayer.point
    for i in 0..<field.rows {
        var str = ""
        for j in 0..<field.columns {
            var currentPoint = field.matrix[Point.transformLocation(row: i, column: j)]
            if Point(i: i, j: j) == playerPoint {
                currentPoint = 7
                
            }
            
            for a in 1..<snakePlayer.body.count{
                if Point(i: i, j: j) == snakePlayer.body[a] {
                    currentPoint = 9
                }
            }
            
            if Point(i: i, j: j) == apple {
                currentPoint = 8
            }
            
            if Point(i: i, j: j) == snakePlayer.body.last {
                currentPoint = 10
            }
            
            str.append("\(currentPoint.convertToField())")
            
        }
        print(str)
    }
    
    print("")
    usleep(100000)
}

func whereApple(snakePlayer: SnakePlayer, apple: Point) -> Bool {
    if snakePlayer.point.column == apple.column {
        return true
    } else if snakePlayer.point.row == apple.row {
        return true
    }
    return false
}

func randomApplePoint(location: [Point]) -> Point {
    
    var isGoodRandom: Bool = false
    var randomPoint: Point = Point(i: 0, j: 0)
    
    while !isGoodRandom {
        let appleI = Int.random(in: 1 ..< field.rows - 1)
        let appleJ = Int.random(in: 1 ..< field.columns - 1)
        randomPoint = Point(i: appleI, j: appleJ)
        
        for i in 0..<location.count {
            if location[i] == randomPoint {
                isGoodRandom = false
                break
            } else {
                isGoodRandom = true
            }
        }
    }
    
    return randomPoint
}

func checkAppleWay(direction: Way, snakePlayer: inout SnakePlayer, apple: inout Point, needGo: inout Bool) {
    var way: Int = 0
    switch direction {
    case .up: way = snakePlayer.way == .left ? Way.right.rawValue : Way.left.rawValue
    case .bottom: way = snakePlayer.way == .left ? Way.left.rawValue : Way.right.rawValue
    case .left: way = snakePlayer.way == .bottom ? Way.right.rawValue : Way.left.rawValue
    case .right: way = snakePlayer.way == .bottom ? Way.left.rawValue : Way.right.rawValue
    }
    turnAndMove(snakePlayer: &snakePlayer, wayValue: way, apple: &apple, needGo: &needGo)
}


// MARK: - Функция нахождения выхода
func startGame() {
    
    var player: SnakePlayer = SnakePlayer()
    
    var apple = randomApplePoint(location: player.body)
    var needGo: Bool = true
    var endGame: Bool = false
    while !endGame {
        needGo = true
        
        printEmojiField(snakePlayer: player, apple: apple)
        if whereApple(snakePlayer: player, apple: apple) {
            
            if player.point.column == apple.column {
                //проверка надо ли повернуть
                if player.point.column == apple.column && player.body[1].column != apple.column {
                    if player.point.row > apple.row {
                        checkAppleWay(direction: Way.up, snakePlayer: &player, apple: &apple, needGo: &needGo)
                    } else if player.point.row < apple.row {
                        checkAppleWay(direction: Way.bottom, snakePlayer: &player, apple: &apple, needGo: &needGo)
                    } else {
                        turnAndMove(snakePlayer: &player, wayValue: Way.bottom.rawValue, apple: &apple, needGo: &needGo)
                    }
                }
                
            } else if player.point.row == apple.row {
                //проверка надо ли повернуть
                if player.point.row == apple.row && player.body[1].row != apple.row {
                    if player.point.column > apple.column {
                        checkAppleWay(direction: Way.left, snakePlayer: &player, apple: &apple, needGo: &needGo)
                    } else if player.point.column < apple.column{
                        checkAppleWay(direction: Way.right, snakePlayer: &player, apple: &apple, needGo: &needGo)
                    } else {
                        turnAndMove(snakePlayer: &player, wayValue: Way.bottom.rawValue, apple: &apple, needGo: &needGo)
                    }
                }
            } else {
                turnAndMove(snakePlayer: &player, wayValue: Way.bottom.rawValue, apple: &apple, needGo: &needGo)
                
            }
            
        }
        
        if frontWayIsFree(matrix: field.matrix, snakePlayer: player) {
            turnAndMove(snakePlayer: &player, wayValue: Way.up.rawValue, apple: &apple, needGo: &needGo)
        } else if rightWayIsFree(matrix: field.matrix, snakePlayer: player) {
            turnAndMove(snakePlayer: &player, wayValue: Way.right.rawValue, apple: &apple, needGo: &needGo)
        } else if leftWayIsFree(matrix: field.matrix, snakePlayer: player) {
            turnAndMove(snakePlayer: &player, wayValue: Way.left.rawValue, apple: &apple, needGo: &needGo)
        } else {
            endGame = true
            print("Игра закончилась! Я пошел спать.")
        }
    }
}


var field: Field = SomeField()

startGame()
