# Generated by Selenium IDE
require "selenium-webdriver"
require "json"

describe "TaskCRUD" do
  before(:all) do
    @mail = "admin@todoapp.com"
    @password = "Administrator."
  end

  before(:each) do
    @driver = Selenium::WebDriver.for :firefox
    @vars = {}

    @driver.get("http://localhost:3000/users/sign_in")
    login(@driver, @mail, @password)
    sleep(1)
  end
  after(:each) do
    #@driver.quit
  end

  it "createTask" do
    name = "Test create task name"
    description = "Test create task description"
    deadline = "2020-03-20"
    priority = "Medium"
    create_task(@driver, name, description, deadline, priority)
  end

  it 'editTask' do
    name = 'Test edit task name'
    description = 'Test edit task description'
    deadline = '2020-03-21'
    priority = 'Medium'
    task_index = create_task(@driver, name, description, deadline, priority)

    # Edit task values
    name = 'Test edit task edited name'
    description = 'Test task description edited'
    deadline = '2020-04-21'
    priority = 'Low'
    edit_task(@driver, task_index, name, description, deadline, priority)
  end

  it 'completeTask' do
    name = 'Test complete task name'
    description = 'Test complete task description'
    deadline = '2020-03-23'
    priority = 'High'
    task_index = create_task(@driver, name, description, deadline, priority)
    complete_task(@driver, task_index)
  end

  it 'deleteTask' do
    name = 'Test delete task name'
    description = 'Test delete task description'
    deadline = '2021-03-23'
    priority = 'Low'
    task_index = create_task(@driver, name, description, deadline, priority)
    delete_task(@driver, task_index)
  end

  it 'create_today_task' do
    name = 'Test create today task name'
    description = 'Test create today task description'
    deadline = (Date.today).to_s
    priority = 'Medium'
    create_task(@driver, name, description, deadline, priority, true)
  end

  it 'create_week_tasks' do
    for day in 0..6 do
      name = 'Test create week day ' + day.to_s + ' task name'
      description = 'Test create week day ' + day.to_s + ' task description'
      deadline = (Date.today + day).to_s
      priority = 'Low'
      create_task(@driver, name, description, deadline, priority, false, true)
    end
  end

end

def create_task(driver, name, description, deadline, priority, today = false, week = false)
  driver.get("http://localhost:3000/")
  # Get pending tasks
  pending = driver.find_element(:id, "lbl_pending_tasks").text
  expected = (pending.to_i + 1)
  expected_str = expected.to_s
  today_tasks = -1
  week_tasks = -1

  if today
    today_tasks = driver.find_element(:id, "lbl_tasks_for_today").text.to_i
  end

  if week
    week_tasks = driver.find_element(:id, "lbl_tasks_for_this_week").text.to_i
  end

  # Click on add new task btn
  element = driver.find_element(:id, "btn_add_task").click

  # Fill in new task form and submit it
  driver.find_element(:id, "task_name").click
  driver.find_element(:id, "task_name").send_keys(name)
  driver.find_element(:id, "task_description").click
  driver.find_element(:id, "task_description").send_keys(description)
  driver.find_element(:id, "task_priority").click
  dropdown = driver.find_element(:id, "task_priority")
  dropdown.find_element(:xpath, "//option[. = '" + priority + "']").click
  driver.find_element(:id, "task_deadline").send_keys(deadline)
  driver.find_element(:id, "btn_task_submit").click

  # ASSERT: check if "pending tasks" card has been updated
  sleep(2)
  expect(driver.find_element(:id, "lbl_pending_tasks").text).to eq (expected_str)

  # ASSERT: check if a new task item has been added to tasks list
  card_item = driver.find_elements(:id, ("task_header_").concat(expected_str))
  expect(card_item.length).to be > 0

  # Open task details to check if all fields are correct.
  driver.find_element(:id, ("task_header_option_").concat(expected_str)).click
  driver.find_element(:id, ("task_details_").concat(expected_str)).click
  sleep(1)

  # ASSERT: check task name
  value_name = driver.find_element(:id, "lbl_task_name_".concat(expected_str)).text
  expect(value_name).to eq(name)

  # ASSERT: check task description
  value_description = driver.find_element(:id, "lbl_task_description_".concat(expected_str)).text
  expect(value_description).to eq(description)

  # ASSERT: check task deadline
  value_deadline = driver.find_element(:id, "lbl_task_deadline_".concat(expected_str)).text
  expect(value_deadline).to eq(deadline)

  # ASSERT: check task priority
  value_priority = driver.find_element(:id, "lbl_task_priority_".concat(expected_str)).text
  expect(value_priority).to eq(priority.downcase)

  if today
    expect(driver.find_element(:id, "lbl_tasks_for_today").text).to eq ((today_tasks + 1).to_s)
  end

  if week
    expect(driver.find_element(:id, "lbl_tasks_for_this_week").text).to eq ((week_tasks + 1).to_s)
  end

  return expected_str
end

def edit_task(driver, task_index, name, description, deadline, priority)

  # Open task details and click on edit task
  driver.find_element(:id, ("task_header_option_").concat(task_index)).click
  driver.find_element(:id, ("task_edit_").concat(task_index)).click
  sleep(1)

  # Fill in edit task form and submit it
  task_name = driver.find_element(:id, "task_name").click
  driver.find_element(:id, "task_name").clear
  driver.find_element(:id, "task_name").send_keys(name)
  driver.find_element(:id, "task_description").click
  driver.find_element(:id, "task_description").clear
  driver.find_element(:id, "task_description").send_keys(description)
  driver.find_element(:id, "task_priority").click
  dropdown = driver.find_element(:id, "task_priority")
  dropdown.find_element(:xpath, "//option[. = '" + priority + "']").click
  driver.find_element(:id, "task_deadline").send_keys(deadline)
  driver.find_element(:id, "btn_task_submit").click

  # Open task details to check if all fields are correct.
  driver.find_element(:id, ("task_header_option_").concat(task_index)).click
  driver.find_element(:id, ("task_details_").concat(task_index)).click
  sleep(1)

  # ASSERT: check task name
  value_name = driver.find_element(:id, "lbl_task_name_".concat(task_index)).text
  expect(value_name).to eq(name)

  # ASSERT: check task description
  value_description = driver.find_element(:id, "lbl_task_description_".concat(task_index)).text
  expect(value_description).to eq(description)

  # ASSERT: check task deadline
  value_deadline = driver.find_element(:id, "lbl_task_deadline_".concat(task_index)).text
  expect(value_deadline).to eq(deadline)

  # ASSERT: check task priority
  value_priority = driver.find_element(:id, "lbl_task_priority_".concat(task_index)).text
  expect(value_priority).to eq(priority.downcase)
end

def complete_task(driver, task_index)
  pending = driver.find_element(:id, "lbl_pending_tasks").text.to_i
  completed = driver.find_element(:id, "lbl_completed_tasks").text.to_i

  # Open task details and click on complete task
  driver.find_element(:id, ("task_header_option_").concat(task_index)).click
  driver.find_element(:id, ("task_complete_").concat(task_index)).click
  sleep(1)

  # ASSERT: task item is not present
  task_item = @driver.find_elements(:id, ("task_header_").concat(task_index))
  expect(task_item.length).to eq(0)

  # ASSERT: there is one less pending task
  expect(driver.find_element(:id, "lbl_pending_tasks").text).to eq ((pending - 1).to_s)

  # ASSERT: there is one more complete task
  expect(driver.find_element(:id, "lbl_completed_tasks").text).to eq ((completed + 1).to_s)
end

def delete_task(driver, task_index)
  pending = driver.find_element(:id, "lbl_pending_tasks").text.to_i

  # Open task details and click on delete task
  driver.find_element(:id, ("task_header_option_").concat(task_index)).click
  driver.find_element(:id, ("task_delete_").concat(task_index)).click
  sleep(1)
  driver.switch_to().alert().accept()
  sleep(1)

  # ASSERT: there is one less pending task
  expect(driver.find_element(:id, "lbl_pending_tasks").text).to eq ((pending - 1).to_s)

  # ASSERT: task item is not present
  task_item = @driver.find_elements(:id, ("task_header_").concat(task_index))
  expect(task_item.length).to eq(0)
end

def login(driver, email, password)
  driver.find_element(:id, "user_email").click
  driver.find_element(:id, "user_email").send_keys(email)
  driver.find_element(:id, "user_password").click
  driver.find_element(:id, "user_password").send_keys(password)
  @driver.find_element(:name, "commit").click
end
