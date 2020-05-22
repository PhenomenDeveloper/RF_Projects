import Foundation

// MARK: - Enum
enum Way: Int {
    case up = 0
    case right = 1
    case bottom = 2
    case left = 3
}

// MARK: - Protocols
protocol Location {
    var row: Int { get set }
    var column: Int { get set }
}

public protocol Maze {
    var rows: Int { get }
    var columns: Int { get }
    var matrix: [Int] { get }
}

public struct SomeMaze: Maze {
    public let rows: Int
    public let columns: Int
    
    public let matrix: [Int]
    
    public init() {
        var instance: [Int] = []

                //           A  B  C  D  E  F  G  H  I  J  K  L  M  O  P  Q  R  S  T
                instance += [1, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1] // 1
                instance += [1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1] // 2
                instance += [1, 0, 1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1] // 3
                instance += [1, 0, 1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1] // 4
                instance += [1, 0, 1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1] // 5
                instance += [1, 0, 0, 1, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 1, 0, 1] // 6
                instance += [1, 1, 0, 1, 0, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 1, 0, 1] // 7
                instance += [1, 0, 0, 0, 0, 1, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1] // 8
                instance += [1, 0, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1] // 9
                instance += [1, 0, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1] // 10
                instance += [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 1] // 11
        
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
        return row * maze.columns + column
    }
    
    
}

// MARK: - Структура игрока
public struct Player {
    var point: Point
    var way: Way
    
    public init(point: Point, way: Int) {
        self.point = point
        
        if let way = Way.init(rawValue: way) {
            self.way = way
        } else {
            print("Оно никогда не вызывается")
            self.way = .bottom
        }
    }
    
}


// MARK: - Функция проверки выхода
func isExit(location: Point) -> Bool {
    if location.row - 1 < 0 || location.row + 1 == maze.rows || location.column  - 1 < 0 || location.column + 1 == maze.columns {
        return true
    } else {
        return false
    }
    
}

// MARK: - Функция поворота и движения
func turnAndMove(player: inout Player, wayValue: Int) {
    let number = (player.way.rawValue + wayValue) % 4
    guard let way = Way.init(rawValue: number) else { return }
    player.way = way
    
    switch player.way {
     case .up:
         player.point.row -= 1
     case .left:
         player.point.column -= 1
     case .right:
         player.point.column += 1
     case .bottom:
         player.point.row += 1
     }
    
}

// MARK: - Функции проверки разных сторон
func frontWayIsFree(matrix: [Int], player: Player) -> Bool {
    let value: Int
    switch player.way {
    case .up:
        value = matrix[Point.transformLocation(row: player.point.row - 1, column: player.point.column)]
    case .left:
        value = matrix[Point.transformLocation(row: player.point.row, column: player.point.column - 1)]
    case .bottom:
        value = matrix[Point.transformLocation(row: player.point.row + 1, column: player.point.column)]
    case .right:
        value = matrix[Point.transformLocation(row: player.point.row, column: player.point.column + 1)]
    }
    return value == 0
    
}

func leftWayIsFree(matrix: [Int], player: Player) -> Bool {
    let value: Int
    switch player.way {
    case .up:
        value = matrix[Point.transformLocation(row: player.point.row, column: player.point.column - 1)]
    case .left:
        value = matrix[Point.transformLocation(row: player.point.row + 1, column: player.point.column)]
    case .bottom:
        value = matrix[Point.transformLocation(row: player.point.row, column: player.point.column + 1)]
    case .right:
        value = matrix[Point.transformLocation(row: player.point.row - 1, column: player.point.column)]
    }
    return value == 0
    
}

func rightWayIsFree(matrix: [Int], player: Player) -> Bool {
    let value: Int
    switch player.way {
    case .up:
        value = matrix[Point.transformLocation(row: player.point.row, column: player.point.column + 1)]
    case .left:
        value = matrix[Point.transformLocation(row: player.point.row - 1, column: player.point.column)]
    case .bottom:
        value = matrix[Point.transformLocation(row: player.point.row, column: player.point.column - 1)]
    case .right:
        value = matrix[Point.transformLocation(row: player.point.row + 1, column: player.point.column)]
    }
    return value == 0
    
}

// MARK: - Функция печати поля лабиринта
func printEmojiMaze(playerPoint: Point) {
    for i in 0..<maze.rows {
        var str = ""
        for j in 0..<maze.columns {
            var currentPoint = maze.matrix[Point.transformLocation(row: i, column: j)]
            if Point(i: i, j: j) == playerPoint {
                currentPoint = 7
                
            }
            str.append("\(currentPoint.convertToField())")
            
        }
        print(str)
    }
    print("")
    usleep(600000)
}

// MARK: - Функция нахождения входа
func findEntrence(maze: Maze) -> Location {
    let random = Int.random(in: 0 ..< 100)
            
    if random > 50 {
        for j in 0..<maze.columns {
            if maze.matrix[j] == 0 {
                return Point(i: 0, j: j)
            }
        }
    } else {
        for j in Point.transformLocation(row: maze.rows - 1, column: 0)..<maze.matrix.count {
            if maze.matrix[j] == 0 {
                return Point(i: maze.rows - 1, j: j - (maze.rows - 1) * maze.columns)
            }
        }
    }
    return Point(i: 0, j: 0)
    
}
// MARK: - Функция нахождения выхода
func findWayOut(maze: Maze, entrence: Location) -> Location {
    var player: Player = Player(point: Point(i: entrence.row == 0 ? 1 : entrence.row - 1, j: entrence.column),
                                way: entrence.row == 0 ? 2 : 0)
    var steps: Int = 0
    while !isExit(location: player.point) {
        printEmojiMaze(playerPoint: player.point)
        
        if rightWayIsFree(matrix: maze.matrix, player: player) {
            turnAndMove(player: &player, wayValue: Way.right.rawValue)
        } else if frontWayIsFree(matrix: maze.matrix, player: player) {
            turnAndMove(player: &player, wayValue: Way.up.rawValue)
        } else if leftWayIsFree(matrix: maze.matrix, player: player) {
            turnAndMove(player: &player, wayValue: Way.left.rawValue)
        } else {
            turnAndMove(player: &player, wayValue: Way.bottom.rawValue)
        }
        steps += 1
    }
    print("Количество шагов для выхода из лабиринта: \(steps)")
    return player.point
    
}


let maze = SomeMaze()

let enter = findEntrence(maze: maze)
print("Вход: ", enter)
findWayOut(maze: maze, entrence: enter)

