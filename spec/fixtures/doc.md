# Documentation for DiscussionsController

The DiscussionsController is a part of the application's controllers that manages the Discussion model. It is responsible for creating, updating, and deleting discussions. It also handles the display of discussions.

## Actions

### Index

The `index` action handles the display of all discussions. It fetches all the discussions from the database, including the associated category and orders them with the pinned discussions appearing first. The result is paginated.

### Show

The `show` action handles the display of a single discussion. It fetches the discussion based on the id passed in the parameters. It also fetches all the posts associated with the discussion, including the user who posted and the content of the post. The posts are ordered by the creation date in ascending order. It also initializes a new post for the discussion.

### New

The `new` action initializes a new discussion and a new post for the discussion.

### Create

The `create` action handles the creation of a new discussion. It initializes a new discussion with the parameters passed and attempts to save it in the database. If the save is successful, it redirects to the discussions page with a success notice. If the save fails, it re-renders the new discussion form with an error status.

### Edit

The `edit` action fetches the discussion to be edited based on the id passed in the parameters.

### Update

The `update` action handles the updating of a discussion. It fetches the discussion to be updated based on the id passed in the parameters and attempts to update it with the new parameters passed. If the update is successful, it broadcasts the updated discussion and redirects to the discussion page with a success notice. If the update fails, it re-renders the edit discussion form with an error status.

### Destroy

The `destroy` action handles the deletion of a discussion. It fetches the discussion to be deleted based on the id passed in the parameters and attempts to delete it from the database. After deletion, it redirects to the discussions page with a success notice.

## Private Methods

### Discussion Params

The `discussion_params` method is a private method that specifies the allowed parameters for a discussion. It requires the discussion to have a name, category_id, and optional pinned and closed attributes. It also allows for nested attributes for posts with a body.

### Set Discussion

The `set_discussion` method is a private method that fetches the discussion based on the id passed in the parameters. It is used as a before action for the show, edit, update, and destroy actions.
