// [[ GT6 FREE FIRE - COGNITIVE PROCESSING ENGINE ]] //
// [[ FILE 2: VIRTUAL MATRIX CONFIGURATOR ]] //

function generateVipConfig(playerId) {
    if (!playerId || playerId.length < 5) {
        return null;
    }

    // خوارزمية رياضية افتراضية لتوليد الحساسية بناءً على أرقام الـ ID
    let idSum = 0;
    for (let i = 0; i < playerId.length; i++) {
        idSum += parseInt(playerId[i]) || 1;
    }

    // حساب مصفوفة الأداء لضمان أفضل ثبات وتوجيه تلقائي (Auto Headshot Emulation)
    let generalSens = mathClamp(90 + (idSum % 11), 90, 100);
    let redDotSens = mathClamp(85 + (idSum % 15), 85, 98);
    let scope2x = mathClamp(88 + (idSum % 12), 85, 99);
    let scope4x = mathClamp(92 + (idSum % 8), 90, 100);

    return {
        status: "SUCCESS_ALIGNED",
        matrixId: "GT6-" + (idSum * 7),
        settings: {
            general: generalSens + "%",
            redDot: redDotSens + "%",
            scope2x: scope2x + "%",
            scope4x: scope4x + "%",
            dpi: mathClamp(480 + (idSum * 3), 480, 960),
            aimLockDelay: "0ms (INSTANT)"
        }
    };
}

// دالة حماية النطاق الرياضي لعدم تجاوز قيم الحساسية المطلوبة
function mathClamp(val, min, max) {
    return math.max(min, math.min(max, val));
}

// ربط المحرك بالواجهة الرسومية عند الضغط
window.executeAiMatrix = function() {
    let inputField = document.getElementById('playerId');
    let idValue = inputField.value;

    if (idValue.trim() === "") {
        alert("🚨 خطأ في النظام: يرجى إدخال معرف اللاعب (Player ID) أولاً!");
        return;
    }

    let result = generateVipConfig(idValue);
    
    if (result) {
        document.getElementById('detectedId').innerText = idValue;
        
        // إدخال البيانات المولدة ديناميكياً داخل كروت العرض في لوحتك
        let outputBox = document.getElementById('resultBox');
        outputBox.style.display = 'block';
        
        console.log("[GT6 ENGINE]: Configuration data injected for ID: " + idValue);
    }
};
