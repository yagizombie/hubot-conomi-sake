# Description
#   日本酒の情報を取得する
#   https://www.sakenote.com/access_tokens　(Sakenote Database API)
#
# Configuration:
#   CONOMI_YD_APP_ID Yahoo! JAPANのWebサービスを利用するためのアプリケーションID
#
# Commands:
#   hubot <text(都道府県)>の酒 - <text(都道府県)>のお酒を探す
#   hubot <text>ってお酒 - <text>についての日本酒情報を表示する
#   hubot <text>なんとか - <text>っぽい日本酒を探す
#
# Author:
#   yagizombie <yanagihara+zombie@brainpad.co.jp>

http = require 'http'

APP_ID = process.env.CONOMI_SAKE_TOKEN

table = {
    "北海道":1,    "ほっかいどう":1,
    "青森県":2,    "青森":2,     "あおもり":2,
    "岩手県":3,    "岩手":3,     "いわて":3,
    "宮城県":4,    "宮城":4,     "みやぎ":4,
    "秋田県":5,    "秋田":5,     "あきた":5,
    "山形県":6,    "山形":6,     "やまがた":6,
    "福島県":7,    "福島":7,     "ふくしま":7,
    "茨城県":8,    "茨城":8,     "いばらき":8,
    "栃木県":9,    "栃木":9,     "とちぎ":9,
    "群馬県":10,   "群馬":10,    "ぐんま":10,
    "埼玉県":11,   "埼玉":11,    "さいたま":11,
    "千葉県":12,   "千葉":12,    "ちば":12,
    "東京都":13,   "東京":13,    "とうきょう":13,
    "神奈川県":14, "神奈川":14,  "かながわ":14,
    "新潟県":15,   "新潟":15,    "にいがた":15,
    "富山県":16,   "富山":16,    "とやま":16,
    "石川県":17,   "石川":17,    "いしかわ":17,
    "福井県":18,   "福井":18,    "ふくい":18,
    "山梨県":19,   "山梨":19,    "やまなし":19,
    "長野県":20,   "長野":20,    "ながの":20,
    "岐阜県":21,   "岐阜":21,    "ぎふ":21,
    "静岡県":22,   "静岡":22,    "しずおか":22,
    "愛知県":23,   "愛知":23,    "あいち":23,
    "三重県":24,   "三重":24,    "みえ":24,
    "滋賀県":25,   "滋賀":25,    "しが":25,
    "京都府":26,   "京都":26,    "きょうと":26,
    "大阪府":27,   "大阪":27,    "おおさか":27,
    "兵庫県":28,   "兵庫":28,    "ひょうご":28,
    "奈良県":29,   "奈良":29,    "なら":29,
    "和歌山県":30, "和歌山":30,  "わかやま":30,
    "鳥取県":31,   "鳥取":31,    "とっとり":31,
    "島根県":32,   "島根":32,    "しまね":32,
    "岡山県":33,   "岡山":33,    "おかやま":33,
    "広島県":34,   "広島":34,    "ひろしま":34,
    "山口県":35,   "山口":35,    "やまぐち":35,
    "徳島県":36,   "徳島":36,    "とくしま":36,
    "香川県":37,   "香川":37,    "かがわ":37,
    "愛媛県":38,   "愛媛":38,    "えひめ":38,
    "高知県":39,   "高知":39,    "こうち":39,
    "福岡県":40,   "福岡":40,    "ふくおか":40,
    "佐賀県":41,   "佐賀":41,    "さが":41,
    "長崎県":42,   "長崎":42,    "ながさき":42,
    "熊本県":43,   "熊本":43,    "くまもと":43,
    "大分県":44,   "大分":44,    "おおいた":44,
    "宮崎県":45,   "宮崎":45,    "みやざき":45,
    "鹿児島県":46, "鹿児島":46,  "かごしま":46,
    "沖縄県":47,   "沖縄":47,    "おきなわ":47
}


module.exports = (robot) ->

    robot.respond /(.+)(の情報|のつく酒|って酒|って日本酒|のお酒|のおさけ|の酒|のさけ|なんとか|何とか)$/i, (msg) ->
        get_sake_info msg, msg.match[1]


    get_sake_info = (msg, keyword="") ->
        p = "/api/v1/sakes"
        p = p + '?token=' + APP_ID
        if keyword of table == true
            p = p + '&prefecture_code=' + table[keyword]
        else
            p = p + '&sake_name=' + encodeURIComponent(keyword)
        console.log "http://www.sakenote.com" + p
        req = http.get { host:'www.sakenote.com', path:p }, (res) ->
            contents = ""
            res.on 'data', (chunk) ->
                contents += "#{chunk}"
            res.on 'end', () ->
                j = JSON.parse contents
                # console.log j

                if j['sakes'].length == 0
                    msg.send "..."
                    return

                rep = ""
                for i, value of j['sakes']
                    rep += "\n『" + value['sake_name'] + " (" + value['sake_furigana'] + ")』 \n"
                    if "maker_name" of value == true
                        rep += "　蔵元: " + value['maker_name'] + "　"
                        if "maker_postcode" of value == true
                            rep += "〒" + value['maker_postcode'] + "　"
                        if "maker_address" of value == true
                            rep += value['maker_address']
                        rep += "\n"
                        if value['maker_url'] != null
                            rep += "　URL: " + value['maker_url'] + "\n"
                msg.send rep

        req.on "error", (e) ->
            msg.send "(boom)ぅぅぅ... {e.message}"
