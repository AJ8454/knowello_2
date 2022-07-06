const isTest = true;
const serverUrl = isTest
    ? "http://15.206.178.102:9004" // this is test
    : "https://api.knowellosys.com"; //http://192.168.1.136:9004 // this is production

const baseUrl = '$serverUrl/api/v3/';
const home = 'home/';
const appbarBannerUrl = '$baseUrl${home}show_banner';
const mainStoryUrl = '$baseUrl${home}main_stories';
const singleStoryUrl = '$baseUrl${home}single_story';
const popularStoryUrl = '$baseUrl${home}popular_stories';
const knowablebuzzingStoryUrl = '$baseUrl${home}knowables_buzzing_stories';
const storyBookmarkLikeUrl = '$baseUrl${home}story_bookmark_like';
const getAllCommentsUrl = '$baseUrl${home}story_comment_list';
const postStoryCommentUrl = '$baseUrl${home}story_comment_add';
const bookmarkStoriesUrl = '$baseUrl${home}bookmarked_stories';
const reelVideoUrl = '$baseUrl${home}videos_list';
const singlereelVideoUrl = '$baseUrl${home}single_video';
const videoCommentsListUrl = '$baseUrl${home}video_comments_list';
const postVideoCommentsUrl = '$baseUrl${home}video_comments_post';
const postVideolikeUrl = '$baseUrl${home}video_like';
