/**
* Smearing
* @param $object 添加拖尾的对象
*/
function Smearing($object) {
    var self = this;
    base(self, LSprite, []);

    self.x = 0;
    self.y = 0;

    self.mode = "";

    self.smearingSprite = new LSprite();
    self.addChild(self.smearingSprite);

    self.object = $object;

    self.originalSprite = new LSprite();
    self.addChild(self.originalSprite);
    self.originalSprite.addChild(self.object);

    self.addEventListener(LEvent.ENTER_FRAME, self.smeared);
}
Smearing.prototype.smeared = function (self) {
    var smearingChild = new SmearingChild(self.originalSprite, self.object);
    self.smearingSprite.addChild(smearingChild);

    for (var key in self.smearingSprite.childList) {
        LTweenLite.to(self.smearingSprite.childList[key], 0.5, {
            alpha: 0,
            onComplete: function (o) {
                self.smearingSprite.removeChild(o);
            }
        });
    }
};
Smearing.prototype.to = function ($duration, $vars) {
    var self = this;

    $vars.onComplete = function () {
        self.mode = "complete";
    }
    LTweenLite.to(self.originalSprite, $duration, $vars);
};

/**
* SmearingChild
* @param $parent 确定拖尾位置的对象
* @param $object 要添加拖尾效果的对象
*/
function SmearingChild($parent, $object) {
    var self = this;
    base(self, LSprite, []);

    self.addChild($object);

    self.x = $parent.x;
    self.y = $parent.y;
    self.alpha = 0.8;
}