import Foundation

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

class TasksMenu : Menu {

	override func addMenus() {
		menusIn[menusDescription.count] = CreateTaskExecute(self, false)
		menusDescription.append("Create a new task")

		menusIn[menusDescription.count] = EditTaskExecute(self, false)
		menusDescription.append("Edit a task")

		menusIn[menusDescription.count] = DeleteTaskExecute(self, false)
		menusDescription.append("Delete a task")

		menusIn[menusDescription.count] = ChangeOrderTaskExecute(self, false)
		menusDescription.append("Show all tasks")
	}

	override func printPrefix() {
		let tasks = Menu.controller.getTasks()
		if (tasks.count == 0) {
			print("There is no task to show.")
		} else {
			for i in 0..<tasks.count {
				print(">\t\(tasks[i])")
			}
		}
	}
}

class CreateTaskExecute : Menu {

	override func show() {}

	override func execute() {
		let title = getValidInput(prompt: "Please enter title:") {
			if ($0 == "") {
				print("Empty title is not valid.")
				return false
			}
			return true
		}
		let content = getValidInput(prompt: "Please enter content:") {
			if ($0! == "") {
				print("Empty content is not valid.")
				return false
			}
			return true
		}
		let piorityString = getValidInput(prompt: "Please enter priority:") {
			if ($0! == "") {
				print("Empty priority is not valid.")
				return false
			} else if Int($0!) == nil {
				print("Non-numeric priority is not valid.")
				return false
			}
			return true
		}
		Menu.controller.createTask(title: title, content: content, priority: Int(piorityString)!)
		self.parent!.show()
		self.parent!.execute()
	}
}

class EditTaskExecute : Menu {

	override func show() {}

	override func execute() {
		let tasks = Menu.controller.getTasks()
		if tasks.count == 0 {
			print("There is no task to edit.")
			self.parent!.show()
			self.parent!.execute()
			return
		}
		for i in 0..<tasks.count {
			print("\(i + 1).\t\(tasks[i])")
		}
		let indexString = getValidInput(prompt: "Please enter index of task you want to edit (0 to escape):") {
			if ($0! == "") {
				print("Empty index is not valid.")
				return false
			} else if Int($0!) == nil {
				print("Non-numeric index is not valid.")
				return false
			} else if !(0 <= Int($0!)! && Int($0!)! <= tasks.count) {
				print("Index out of range.")
				return false
			}
			return true
		}
		if Int(indexString)! == 0 {
			self.parent!.show()
			self.parent!.execute()
		}
		print("Please enter title (enter to escape):", terminator: " ")
		let title = readLine()
		print("Please enter content (enter to escape):", terminator: " ")
		let content = readLine()
		let piorityString = getValidInput(prompt: "Please enter priority (enter to escape):") {
			if $0! != "" && Int($0!) == nil {
				print("Non-numeric priority is not valid.")
				return false
			}
			return true
		}
		Menu.controller.editTask(task: tasks[Int(indexString)! - 1], newTitle: title, newContent: content, newPriority: Int(piorityString))
		self.parent!.show()
		self.parent!.execute()
	}
}

class DeleteTaskExecute : Menu {

	override func show() {}

	override func execute() {
		let tasks = Menu.controller.getTasks()
		if tasks.count == 0 {
			print("There is no task to delete.")
			self.parent!.show()
			self.parent!.execute()
			return
		}
		for i in 0..<tasks.count {
			print("\(i + 1).\t\(tasks[i])")
		}
		let indexString = getValidInput(prompt: "Please enter index of task you want to delete (0 to escape):") {
			if ($0! == "") {
				print("Empty index is not valid.")
				return false
			} else if Int($0!) == nil {
				print("Non-numeric index is not valid.")
				return false
			} else if !(0 <= Int($0!)! && Int($0!)! <= tasks.count) {
				print("Index out of range.")
				return false
			}
			return true
		}
		if Int(indexString)! != 0 {
			Menu.controller.deleteTask(task: tasks[Int(indexString)! - 1])
		}
		self.parent!.show()
		self.parent!.execute()
	}
}

class ChangeOrderTaskExecute : Menu {

	override func show() {}

	override func execute() {
		print("1. Sorted by title")
		print("2. Sorted by priority")
		print("3. Sorted by creation date")
		let indexString = getValidInput(prompt: "How do you want to sort tasks?") {
			if ($0! == "") {
				print("Empty index is not valid.")
				return false
			} else if Int($0!) == nil {
				print("Non-numeric index is not valid.")
				return false
			} else if !(1 <= Int($0!)! && Int($0!)! <= 3) {
				print("Index out of range.")
				return false
			}
			return true
		}
		let sortByInt = Int(indexString)!
		var sortBy: SortBy
		if (sortByInt == 1) {
			sortBy = SortBy.BY_TITLE
		} else if (sortByInt == 2) {
			sortBy = SortBy.BY_PRIORITY
		} else {
			sortBy = SortBy.BY_DATE
		}
		print("1. Ascending")
		print("2. Descending")
		let dirString = getValidInput(prompt: "In which direction?") {
			if ($0! == "") {
				print("Empty index is not valid.")
				return false
			} else if Int($0!) == nil {
				print("Non-numeric index is not valid.")
				return false
			} else if !(1 <= Int($0!)! && Int($0!)! <= 2) {
				print("Index out of range.")
				return false
			}
			return true
		}
		var ascending = false
		if (Int(dirString)! == 1) {
			ascending = true
		}
		Menu.controller.changeOrder(sortBy: sortBy, ascending: ascending)
		self.parent!.show()
		self.parent!.execute()
    }
}
