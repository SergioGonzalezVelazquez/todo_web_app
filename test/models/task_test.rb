require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  test "should not save article without title" do
    article = Task.new
    assert article.save
  end
end
