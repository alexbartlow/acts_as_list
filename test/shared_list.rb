module Shared
  module List
    def setup
      (1..4).each do |counter|
        node = ListMixin.new parent_id: 5
        node.save!
      end
    end

    def test_initial_order
      assert_equal ListMixin.order("id ASC").map(&:pos), [1,2,3,4]
    end
  end
end
