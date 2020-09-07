//--パーティクル----------
$(function () {
  particlesJS("particles-js", {
    particles: {
      //--シェイプの設定----------
      number: {
        value: 30, //シェイプの数
        density: {
          enable: true, //シェイプの密集度を変更するか否か
          value_area: 200, //シェイプの密集度
        },
      },
      shape: {
        type: "circle", //シェイプの形（circle:丸、edge:四角、triangle:三角、polygon:多角形、star:星型、image:画像）
        stroke: {
          width: 0, //シェイプの外線の太さ
          color: "#ffcc00", //シェイプの外線の色
        },
        //typeをpolygonにした時の設定
        polygon: {
          nb_sides: 5, //多角形の角の数
        },
        //typeをimageにした時の設定
        image: {
          src: "images/hoge.png",
          width: 100,
          height: 100,
        },
      },
      color: {
        value: "#B76CFD", //シェイプの色
      },
      opacity: {
        value: 1, //シェイプの透明度
        random: false, //シェイプの透明度をランダムにするか否か
        anim: {
          enable: false, //シェイプの透明度をアニメーションさせるか否か
          speed: 20, //アニメーションのスピード
          opacity_min: 0.1, //透明度の最小値
          sync: false, //全てのシェイプを同時にアニメーションさせるか否か
        },
      },
      size: {
        value: 3, //シェイプの大きさ
        random: true, //シェイプの大きさをランダムにするか否か
        anim: {
          enable: false, //シェイプの大きさをアニメーションさせるか否か
          speed: 40, //アニメーションのスピード
          size_min: 0.1, //大きさの最小値
          sync: false, //全てのシェイプを同時にアニメーションさせるか否か
        },
      },
      //--------------------

      //--線の設定----------
      line_linked: {
        enable: true, //線を表示するか否か
        distance: 150, //線をつなぐシェイプの間隔
        color: "#ffffff", //線の色
        opacity: 0.4, //線の透明度
        width: 1, //線の太さ
      },
      //--------------------

      //--動きの設定----------
      move: {
        speed: 2, //シェイプの動くスピード
        straight: false, //個々のシェイプの動きを止めるか否か
        direction: "none", //エリア全体の動き(none、top、top-right、right、bottom-right、bottom、bottom-left、left、top-leftより選択)
        out_mode: "out", //エリア外に出たシェイプの動き(out、bounceより選択)
      },
      //--------------------
    },

    interactivity: {
      detect_on: "canvas",
      events: {
        //--マウスオーバー時の処理----------
        onhover: {
          enable: true, //マウスオーバーが有効か否か
          mode: "repulse", //マウスオーバー時に発動する動き(下記modes内のgrab、repulse、bubbleより選択)
        },
        //--------------------

        //--クリック時の処理----------
        onclick: {
          enable: true, //クリックが有効か否か
          mode: "push", //クリック時に発動する動き(下記modes内のgrab、repulse、bubble、push、removeより選択)
        },
        //--------------------
      },

      modes: {
        //--カーソルとシェイプの間に線が表示される----------
        grab: {
          distance: 400, //カーソルからの反応距離
          line_linked: {
            opacity: 1, //線の透明度
          },
        },
        //--------------------

        //--シェイプがカーソルから逃げる----------
        repulse: {
          distance: 200, //カーソルからの反応距離
        },
        //--------------------

        //--シェイプが膨らむ----------
        bubble: {
          distance: 400, //カーソルからの反応距離
          size: 40, //シェイプの膨らむ大きさ
          opacity: 8, //膨らむシェイプの透明度
          duration: 2, //膨らむシェイプの持続時間(onclick時のみ)
          speed: 3, //膨らむシェイプの速度(onclick時のみ)
        },
        //--------------------

        //--シェイプが増える----------
        push: {
          particles_nb: 4, //増えるシェイプの数
        },
        //--------------------

        //--シェイプが減る----------
        remove: {
          particles_nb: 2, //減るシェイプの数
        },
        //--------------------
      },
    },
    retina_detect: true, //Retina Displayを対応するか否か
    resize: true, //canvasのサイズ変更にわせて拡大縮小するか否か
  });

  // 画像プレビュー
  //DataTransferオブジェクトで、データを格納する箱を作る
  var dataBox = new DataTransfer();
  //querySelectorでfile_fieldを取得
  var file_field = document.querySelector("input[type=file]");
  //fileが選択された時に発火するイベント
  $("#img-file").change(function () {
    $.each(this.files, function (i, file) {
      //FileReaderのreadAsDataURLで指定したFileオブジェクトを読み込む
      var fileReader = new FileReader();

      //DataTransferオブジェクトに対して、fileを追加
      dataBox.items.add(file);
      //DataTransferオブジェクトに入ったfile一覧をfile_fieldの中に代入
      file_field.files = dataBox.files;
      fileReader.readAsDataURL(file);
      //読み込みが完了すると、srcにfileのURLを格納
      fileReader.onloadend = function () {
        var src = fileReader.result;
        var html = `<div class='item-image' data-image=${file.name}>
                    <div class=' item-image__content'>
                      <div class='item-image__content--icon'>
                        <img src=${src} width="100" height="100" class="profile__img" >
                      </div>
                    </div>
                    <div class='item-image__operetion'>
                      <div class='item-image__operetion--delete post__images__delete_btn'>削除</div>
                    </div>
                  </div>`;
        //image_box__container要素の前にhtmlを差し込む
        $("#image-box__container").before(html);
      };
    });
  });
  //削除ボタンをクリックすると発火するイベント
  $(document).on("click", ".item-image__operetion--delete", function () {
    //削除を押されたプレビュー要素を取得
    var target_image = $(this).parent().parent();
    //削除を押されたプレビューimageのfile名を取得
    var target_name = $(target_image).data("image");
    //プレビューがひとつだけの場合、file_fieldをクリア
    if (file_field.files.length == 1) {
      //inputタグに入ったファイルを削除
      $("input[type=file]").val(null);
      dataBox.clearData();
      console.log(dataBox);
    } else {
      //プレビューが複数の場合
      $.each(file_field.files, function (i, input) {
        //削除を押された要素と一致した時、index番号に基づいてdataBoxに格納された要素を削除する
        if (input.name == target_name) {
          dataBox.items.remove(i);
        }
      });
      //DataTransferオブジェクトに入ったfile一覧をfile_fieldの中に再度代入
      file_field.files = dataBox.files;
    }
    //プレビューを削除
    target_image.remove();
    //image-box__containerクラスをもつdivタグのクラスを削除のたびに変更
    var num = $(".item-image").length;
    $("#image-box__container").show();
    $("#image-box__container").attr("class", `item-num-${num}`);
  });
});
