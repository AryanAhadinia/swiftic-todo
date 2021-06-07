class Category : CustomStringConvertible {
	var name: String
	var tasks: Array<Task>

	init(name: String) {
		self.name = name
		self.tasks = Array()
	}
	
	public var description: String {
	    if tasks.count == 0 {
	        return "\(name) with no task"
	    } else if tasks.count == 1 {
			return "\(name) with 1 task"
		}
	    return "\(name) with \(tasks.count) tasks"
	}
}

class Task : Equatable, CustomStringConvertible  {
	static var idGenerator = 0

	var id: Int
	var title: String
	var content: String
	var priority: Int
	var creationDate: Date
	var category: Category?

	public init(title: String, content: String, priority: Int) {
		self.id = Task.idGenerator
		self.title = title
		self.content = content
		self.priority = priority
		self.creationDate = Date()
		self.category = nil
		Task.idGenerator += 1
	}

	public var description: String {
		let dateformat = DateFormatter()
        dateformat.dateFormat = "EEEE, MMM d, yyyy"
		dateformat.timeZone = TimeZone.current
        let formattedDateDay = dateformat.string(from: creationDate)
		dateformat.dateFormat = "HH:mm:ss"
		let formattedDateHour = dateformat.string(from: creationDate)
		return "\"\(title)\": \"\(content)\" with priority \(priority) created on \(formattedDateDay) at \(formattedDateHour)"
	}

	public static func == (o1: Task, o2: Task) -> Bool{
        return o1.id == o2.id
    }
}

class Controller {
	var tasks: Array<Task>
	var categories: Array<Category>

	var sortByState: SortBy
	var ascendingState: Bool

	public init() {
		self.tasks = []
		self.categories = []
		self.sortByState = SortBy.BY_PRIORITY
		self.ascendingState = true
	}

	public func createTask(title: String, content: String, priority: Int) {
		tasks.append(Task(title: title, content: content, priority: priority))
		reorder()
	}

	public func getTasks() -> Array<Task> {
		return tasks
	}

	public func changeOrder(sortBy: SortBy, ascending: Bool) {
		self.sortByState = sortBy
		self.ascendingState = ascending
		switch sortBy {
			case SortBy.BY_TITLE: 
				if (ascending){
					self.tasks = self.tasks.sorted(by: { $0.title < $1.title })
				} else {
					self.tasks = self.tasks.sorted(by: { $0.title > $1.title })
				}
			case SortBy.BY_DATE:
				if (ascending){
					self.tasks = self.tasks.sorted(by: { $0.creationDate < $1.creationDate })
				} else {
					self.tasks = self.tasks.sorted(by: { $0.creationDate > $1.creationDate })
				}
			case SortBy.BY_PRIORITY:
				if (ascending){
					self.tasks = self.tasks.sorted(by: { $0.priority < $1.priority })
				} else {
					self.tasks = self.tasks.sorted(by: { $0.priority > $1.priority })
				}
		}
	}

	public func reorder() {
		changeOrder(sortBy: self.sortByState, ascending: self.ascendingState)
	}

	public func editTask(task: Task, newTitle: String?, newContent: String?, newPriority: Int?) {
		if newPriority != nil {
			task.priority = newPriority!
		}
		if !(newContent ?? "").isEmpty {
			task.content = newContent!
		}
		if !(newTitle ?? "").isEmpty {
			task.title = newTitle!
		}
		reorder()
	}

	public func deleteTask(task: Task) {
		tasks.removeAll() {$0 == task}
		if task.category != nil{
			task.category!.tasks.removeAll(where: {$0 == task})
		}
	}

	public func createCategory(name: String) {
		categories.append(Category(name: name))
	}

	public func addTaskToCategory(task: Task, category: Category) {
		if task.category != nil {
			task.category!.tasks.removeAll(where: {$0 == task})
		}
		task.category = category
		category.tasks.append(task)
	}

	public func getCategories() -> Array<Category> {
		return self.categories
	}

	public func isCategoryNameUsed(name : String) -> Bool {
		for c in categories {
			if c.name == name {
				return true
			}
		}
		return false
	}
}

enum SortBy {
	case BY_TITLE
	case BY_PRIORITY
	case BY_DATE
}

class Menu {
	static let controller = Controller()

	var parent: Menu?
	var menusIn: Dictionary<Int, Menu>
	var menusDescription: Array<String>

	public init(_ parent: Menu?, _ leaf: Bool) {
		self.parent = parent
		self.menusIn = Dictionary()
		self.menusDescription = Array()
		if !leaf {
 			if parent == nil {
				menusIn[menusDescription.count] = ExitExecute(self, true)
				menusDescription.append("Exit")
			} else {
				menusIn[menusDescription.count] = BackExecute(self, true)
				menusDescription.append("Back")
			}
		}
		addMenus()
	}

	public func addMenus() {}

	public func printPrefix() {}

	public func show() {
		printPrefix()
		for i in 0..<menusDescription.count {
			print("\(i). \(menusDescription[i])")
		}
	}

	public func execute() {
		print("Please enter your command index:", terminator: " ")
		let index = Int(readLine()!)
		if index == nil {
			print("Invalid command.")
			self.execute()
		} else if !(0 <= index! && index! < menusDescription.count) {
			print("Index out of range.")
			self.execute()
		} else {
			let next = menusIn[index!]!
			next.show()
			next.execute()
		}
	}

	public func getValidInput(prompt p: String, validator v: (String?) -> Bool) -> String {
		var userInput: String?
		repeat {
			print(p, terminator: " ")
			userInput = readLine()
		} while !v(userInput)
		return userInput!
	}
}

class ExitExecute : Menu {

	override func show() {
		print("Good to see you!")
		Thread.sleep(forTimeInterval: 3)
	}

	override func execute() {
		exit(0)
	}
}

class BackExecute : Menu {

	override func show() {}

	override func execute() {
		self.parent!.parent!.show()
		self.parent!.parent!.execute()
	}
}

class RootMenu : Menu {

	override func addMenus() {
		menusIn[menusDescription.count] = TasksMenu(self, false)
		menusDescription.append("My tasks")

		menusIn[menusDescription.count] = ManageCategoriesMenu(self, false)
		menusDescription.append("Manage categories")
	}
}