pragma solidity ^0.5.0;

contract SocialNetwork {
    string public name;
    uint public postCount = 0;
    mapping(uint => Post) public posts;

    struct Post {
        uint id;
        string content;
        uint tipAmount;
        address payable author;
    }
    

    event postCreated(
        uint id,
        string content,
        uint tipAmount,
        address payable author
    );

    event postTipped(
        uint id,
        string content,
        uint tipAmount,
        address payable author
    );

    constructor() public {
        name = "Study Social Network";
    }

    function createPost(string memory _content) public {
        // Requires a valid content
        require(bytes(_content).length > 0);
        // Add a number to the post count
        postCount ++;

        // Create the post
        posts[postCount] = Post(postCount, _content, 0, msg.sender);
        
        // Trigger an event that tracks the values stored inside of the post
        emit postCreated(postCount, _content, 0, msg.sender);
    }

    function tipPost(uint _id) public payable {
        // Make sure the id is valid
        require(_id > 0 && _id <= postCount);

        // Fetch the post
        Post memory _post = posts[_id];

        // Fetch the author of the post
        address payable _author = _post.author;

        // Pay the author
        address(_author).transfer(msg.value);

        // Increment the tip amount of the post
        _post.tipAmount = _post.tipAmount + msg.value;

        // Update the post
        posts[_id] = _post;

        // Trigger an event
        emit postTipped(postCount, _post.content, _post.tipAmount, _author);

    }
}

