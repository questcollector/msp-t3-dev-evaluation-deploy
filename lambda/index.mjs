export const handler = async(event) => {
    // event parsing, user_id 추출
    console.log("event 출력", event);
    
    const body = Buffer.from(event.body, "base64").toString('utf8')
    console.log("body", body)

    const map = new Map(body.split("&").map(v => {
        return v.split("=");
    }))

    const userId = map.get("user_id")
    console.log("parsed userId", userId)
    
    // user_id로 api 호출
    const apiHost = process.env.EVALUATION_API
    const startDate = process.env.START_DATE
    const endDate = process.env.END_DATE

    const uri = `http://${apiHost}:8080/api/evaluation/slackUserId/?slackUserId=${userId}&startDate=${startDate}&endDate=${endDate}`
    console.log(uri)
    
    let response = {
            "response_type": "in_channel",
            "text": "지금은 결과를 확인할 수 없습니다."
    };
    try {
        /*global fetch*/
        const res = await fetch(uri);
        const data = await res.json();
        console.log(data);
        
        response["text"] = data['reason'];
    } catch (e) {
        console.error(e)
    }
    
    return response;
};
