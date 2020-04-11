# Generated by Selenium IDE
require "selenium-webdriver"
require "json"

describe "UserAuth" do
  before(:all) do
    @name = "test"
    @surname = "user"
    @complete = @name + " " + @surname
    @nick = "test16User"
    @mail = "test16@user.com"
    @password = "Qwerty12345?-"
  end

  before(:each) do
    @driver = Selenium::WebDriver.for :firefox
    @vars = {}
  end
  after(:each) do
    #@driver.quit
  end

  it "createAccount_Success" do
    @driver.get("http://localhost:3000/users/sign_in")
    @driver.find_element(:link_text, "Create an Account").click

    # Create new account
    create_account(@driver, @name, @surname, @nick, @mail, @password)
    sleep(2)

    # ASSERT: User is logged in
    check_loggedIn(@driver, "Inbox")

    # Read account information to check that the user has been registered correctly
    @driver.find_element(:id, "user_profile_photo").click
    @driver.find_element(:id, "user_account_edit").click
    sleep(1)

    first_name = @driver.find_element(:xpath, "//input[contains(@name, 'user[first_name]')]").attribute("value")
    expect(first_name).to eq(@complete)

    last_name = @driver.find_element(:xpath, "//input[contains(@name, 'user[surname]')]").attribute("value")
    expect(last_name).to eq(@surname)

    username = @driver.find_element(:xpath, "//input[contains(@name, 'user[username]')]").attribute("value")
    expect(username).to eq(@nick)

    usermail = @driver.find_element(:xpath, "//input[contains(@name, 'user[email]')]").attribute("value")
    expect(usermail).to eq(@mail)

    # Logout
    logout(@driver)
  end

  it "createAccount_FailsStrongPwd" do
    @driver.get("http://localhost:3000/users/sign_in")
    @driver.find_element(:link_text, "Create an Account").click

    # Create new account
    create_account(@driver, @name, @surname, @nick, @mail, "hello")
    sleep(1)

    # ASSERT: Password validation error is present
    pwd_error = @driver.find_elements(:xpath, "/html/body/div/div/div/div/div[2]/div/form/div[4]/div[1]/div/p")
    expect(pwd_error.length).to eq(1)
  end
  
  it "createAccount_FailsMailFormat" do
    @driver.get("http://localhost:3000/users/sign_in")
    @driver.find_element(:link_text, "Create an Account").click

    # Create new account
    create_account(@driver, @name, @surname, @nick, "Hi", @password)
    sleep(1)

    # Mail validation error is present
    mail_error = @driver.find_elements(:xpath, "/html/body/div/div/div/div/div[2]/div/form/div[3]/p")
    expect(mail_error.length).to eq(1)
  end


  it "login" do
    @driver.get("http://localhost:3000/users/sign_in")
    login(@driver, @mail, @password)

    sleep(1)
    check_loggedIn(@driver, "Inbox")

    logout(@driver)
  end

  it "editUserProfile" do
    @driver.get("http://localhost:3000/users/sign_in")
    login(@driver, @mail, @password)
    sleep(1)
    check_loggedIn(@driver, "Inbox")

    @driver.find_element(:id, "user_profile_photo").click
    @driver.find_element(:id, "user_account_edit").click
    sleep(1)

    nameEdit = 'testEDIT'
    surnameEdit = 'userEDIT'
    nickEdit = 'testUserEDIT' 
    completeEdit = nameEdit + " "+surnameEdit

    @driver.find_element(:id, "user_first_name").click
    @driver.find_element(:id, "user_first_name").send_keys(nameEdit)
    @driver.find_element(:id, "user_surname").click
    @driver.find_element(:id, "user_surname").send_keys(surnameEdit)
    @driver.find_element(:id, "user_username").click
    @driver.find_element(:id, "user_username").send_keys(nickEdit)
    @driver.find_element(:name, "commit").click


    # Read edited information
    @driver.find_element(:id, "user_profile_photo").click
    @driver.find_element(:id, "user_account_edit").click
    sleep(1)

    first_nameE = @driver.find_element(:xpath, "//input[contains(@name, 'user[first_name]')]").attribute("value")
    expect(first_nameE).to eq(completeEdit)

    last_nameE = @driver.find_element(:xpath, "//input[contains(@name, 'user[surname]')]").attribute("value")
    expect(last_nameE).to eq(surnameEdit)

    usernameE = @driver.find_element(:xpath, "//input[contains(@name, 'user[username]')]").attribute("value")
    expect(usernameE).to eq(nickEdit)
  end

  it "deleteAccount" do
    @driver.get("http://localhost:3000/users/sign_in")
    login(@driver, @mail, @password)
    sleep(1)
    check_loggedIn(@driver, "Inbox")

    @driver.find_element(:id, "user_profile_photo").click
    @driver.find_element(:id, "user_account_edit").click

    sleep(1)
    @driver.find_element(:id, "user_account_delete").click
    expect(@driver.switch_to.alert.text).to eq("Are you sure?")
    @driver.switch_to.alert.accept
    sleep(1)

    #ASSERT: Check that we are in login page
    pwd_error = @driver.find_elements(:id, "btn_login")
    expect(pwd_error.length).to eq(1)

    #ASSERT: user does not exists
    login(@driver, @mail, @password)
    sleep(1)
    pwd_error = @driver.find_elements(:id, "btn_login")
    expect(pwd_error.length).to eq(1)
  end


end

def create_account(driver, name, surname, nick, mail, password)
  driver.find_element(:id, "user_first_name").click
  driver.find_element(:id, "user_first_name").send_keys(name)
  driver.find_element(:id, "user_surname").click
  driver.find_element(:id, "user_surname").send_keys(surname)
  driver.find_element(:id, "user_username").click
  driver.find_element(:id, "user_username").send_keys(nick)
  driver.find_element(:id, "user_email").click
  driver.find_element(:id, "user_email").send_keys(mail)
  driver.find_element(:id, "user_password").click
  driver.find_element(:id, "user_password").send_keys(password)
  driver.find_element(:id, "user_password_confirmation").click
  driver.find_element(:id, "user_password_confirmation").send_keys(password)
  driver.find_element(:name, "commit").click
end

def login(driver, email, password)
  driver.find_element(:id, "user_email").click
  driver.find_element(:id, "user_email").send_keys(email)
  driver.find_element(:id, "user_password").click
  driver.find_element(:id, "user_password").send_keys(password)
  @driver.find_element(:name, "commit").click
end

def check_loggedIn(driver, page_name)
  # ASSERT: User is logged
  expect(driver.find_element(:id, "page_title").text).to eq (page_name)
end

def logout(driver)
  driver.find_element(:id, "user_profile_photo").click
  driver.find_element(:id, "user_logout").click
  sleep(1)

  # Confirm
  driver.find_element(:id, "user_logout_confirm").click
  sleep(1)

  #Check that we are in login page
  pwd_error = @driver.find_elements(:id, "btn_login")
  expect(pwd_error.length).to eq(1)
end
