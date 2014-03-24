require 'active_record'
require './lib/employee'
require './lib/division'
require './lib/project'
require 'pry'

datbase_configuration = YAML::load(File.open('./db/config.yml'))
development_configuration = datbase_configuration['development']
ActiveRecord::Base.establish_connection(development_configuration)

def main_menu
  puts "Welcome to the Employee Tracker!"
  puts "Press 'e' for Employee Menu"
  puts "Press 'd' for Division Menu"
  puts "Press 'p' for Project Menu"
  puts "Press 'x' to exit"

  main_input = gets.chomp.downcase
  case main_input
  when 'e'
    employee_menu
  when 'd'
    division_menu
  when 'p'
    project_menu
  when 'x'
    puts "Good-bye!"
  else
    puts "Please enter a valid option."
    main_menu
  end
end

def employee_menu
  puts "Press 'a' to add a new employee"
  puts "Press 'l' to list all the employees in the company database"
  puts "Press 'm' to go back to the main menu"

  employee_input = gets.chomp.downcase
  case employee_input
  when 'a'
    employee_add
  when 'l'
    employee_list
  when 'm'
    main_menu
  else
    puts "Please enter a valid input"
    employee_menu
  end
end

def employee_add
   puts "What employee would you like to add to the company database"
   name = gets.chomp
   puts "Which division would you like him to work for?"
   division_name = gets.chomp
   division_id = Division.find_by name: division_name
   employee = Employee.new({:name => name, :division_id => division_id.id})
   employee.save
   puts "'#{name}' has been added to your database"
   employee_menu
end

def employee_list
  puts "Employee List: \n"
  list = Employee.all
  list.each { |employee| puts employee.name}
  employee_menu
end

def division_menu
  puts "Press 'a' to add a new division"
  puts "Press 'l' to list all the divisions in the company database"
  puts "Press 'm' to go back to the main menu"

  input = gets.chomp
  case input
  when 'a'
    division_add
  when 'l'
    division_list
  when 'm'
    main_menu
  else
    'Please enter a valid input'
    division_menu
  end
end

def division_add
  puts "What division would like to add to the company database? "
  name = gets.chomp
  division = Division.new({:name => name})
  division.save
  puts "'#{name}' has been added to your database"
  division_menu
end

def division_list
  puts "Division List: \n"
  list = Division.all
  list.each { |division| puts division.name}
  puts "Select a division to view its employees"
  division_choice = gets.chomp
  select_division = Division.where({:name => division_choice}).first
  select_division.employees.each { |employee| puts "~ #{employee.name}" }
  puts "\n"
  division_menu
end

def project_menu
  puts "Press 'a' to add a new project"
  puts "Press 'l' to list all the projects in the company database"

  input = gets.chomp
  case input
  when 'a'
    project_add
  when 'l'
    project_list
  when 'm'
    main_menu
  else
    'Please enter a valid input'
    project_menu
  end
end

def project_add
  puts "What project would you like to add to the company database "
  name = gets.chomp
  project = Project.new({:name => name})
  project.save
  puts "'#{name}' has been added to your database"
  project_menu
end

def add_employee_to_project
  puts "Choose a project"
  project = gets.chomp
  choose_project = Project.find_by name: project
  puts "Which employee would you like to add to this project?"
  Employee.all.each { |employee| puts employee.name}
  employee = gets.chomp
  employee_to_add = Employee.find_by name: employee
  choose_project.update(employee_id: employee_to_add.id)
  puts "****************"
  puts "Successfully updated!"
  puts "****************"
  project_list
end

def project_list


  puts "Project List: \n"
  list = Project.all
  list.each do |project|
    if project.employee_id == nil
      puts project.name.upcase
      puts "--employees unassigned"
    else
      puts project.name.upcase
      puts "--#{project.employee.name}"
    end
    ###employee.projects.name????
  end
  puts "Add employee to project? y/n?"

  input = gets.chomp

  case input
  when 'y'
    add_employee_to_project
  when 'n'
    project_menu
  else
    puts 'invalid'
    project_list
  end
end

main_menu
