# ActsAsList

## Description

This `acts_as` extension provides the capabilities for sorting and reordering a number of objects in a list. The class that has this specified needs to have a `position` column defined as an integer on the mapped database table.

This is a fork of the original gem that strips out a large portion of the
original public API. However, it uses postgres' window functions to ensure that
the lists are always consistent. There may exist gaps when removing an item out
of a list, however as long as the position is updated using the standard
setters/save, positions in the list will *never* collide.

Even if a collision is somehow caused, the next re-shuffle of the list will
remove the position collision. This did not happen with the original
`acts_as_list` - it was possible to create a situation where no normal
operations would remove the collision.

## Installation

In your Gemfile:

    gem 'acts_as_list'

Or, from the command line:

    gem install acts_as_list

## Example

At first, you need to add a `position` column to desired table:

    rails g migration AddPositionToTodoItem position:integer
    rake db:migrate
    
After that you can use `acts_as_list` method in the model: 

```ruby
class TodoList < ActiveRecord::Base
  has_many :todo_items, -> { order(position: :asc) }
end
    
class TodoItem < ActiveRecord::Base
  belongs_to :todo_list
  acts_as_list scope: :todo_list
end

todo_list = TodoList.find(...)    
todo_list.position.first.update_attributes(position: 2)
```

### Methods That Return Attributes of the Item's List Position
- `list_item.first?`
- `list_item.last?`
- `list_item.in_list?`
- `list_item.not_in_list?`
- `list_item.default_position?`
- `list_item.higher_item`
- `list_item.higher_items` will return all the items above `list_item` in the list (ordered by the position, ascending)
- `list_item.lower_item`
- `list_item.lower_items` will return all the items below `list_item` in the list (ordered by the position, ascending)

## Notes
If the `position` column has a default value, then there is a slight change in behavior, i.e if you have 4 items in the list, and you insert 1, with a default position 0, it would be pushed to the bottom of the list. Please look at the tests for this and some recent pull requests for discussions related to this.

All `position` queries (select, update, etc.) inside gem methods are executed without the default scope (i.e. `Model.unscoped`), this will prevent nasty issues when the default scope is different from `acts_as_list` scope.

The `position` column is set after validations are called, so you should not put a `presence` validation on the `position` column.


If you need a scope by a non-association field you should pass an array, containing field name, to a scope:
```ruby
class TodoItem < ActiveRecord::Base
  # `kind` is a plain text field (e.g. 'work', 'shopping', 'meeting'), not an association
  acts_as_list scope: [:kind]
end
```

## More Options
- `column`
default: 'position'. Use this option if the column name in your database is different from position.
- `top_of_list`
default: '1'. Use this option to define the top of the list. Use 0 to make the collection act more like an array in its indexing.
- `add_new_at`
default: ':bottom'. Use this option to specify whether objects get added to the :top or :bottom of the list. `nil` will result in new items not being added to the list on create, i.e, position will be kept nil after create.

## Versions
All versions `0.1.5` onwards require Rails 3.0.x and higher.

## Build Status
[![Build Status](https://secure.travis-ci.org/swanandp/acts_as_list.png)](https://secure.travis-ci.org/swanandp/acts_as_list)

## Workflow Status
[![WIP Issues](https://badge.waffle.io/swanandp/acts_as_list.png)](http://waffle.io/swanandp/acts_as_list)

## Roadmap

1. Sort based feature
2. Rails 4 compatibility and bye bye Rails 2! Older versions would of course continue to work with Rails 2, but there won't be any support on those.

## Contributing to `acts_as_list`
 
- Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
- Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
- Fork the project
- Start a feature/bugfix branch
- Commit and push until you are happy with your contribution
- Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
- Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.
- I would recommend using Rails 3.1.x and higher for testing the build before a pull request. The current test harness does not quite work with 3.0.x. The plugin itself works, but the issue lies with testing infrastructure.

## Copyright

Copyright (c) 2007 David Heinemeier Hansson, released under the MIT license
