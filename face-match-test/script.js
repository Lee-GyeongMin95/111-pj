const imageUpload1 = document.getElementById('imageUpload1');
const imageUpload2 = document.getElementById('imageUpload2');
const image1 = document.getElementById('image1');
const image2 = document.getElementById('image2');
const startButton = document.getElementById('start-button');
const loadingMessage = document.getElementById('loading-message');
const resultText = document.getElementById('result-text');

// Load models
Promise.all([
    faceapi.nets.tinyFaceDetector.loadFromUri('./weights'),
    faceapi.nets.faceLandmark68Net.loadFromUri('./weights'),
    faceapi.nets.faceRecognitionNet.loadFromUri('./weights'),
]).then(setup);

function setup() {
    console.log('Models loaded');
    startButton.disabled = false;
    startButton.textContent = '궁합 분석 시작';
}

function handleImageUpload(event, imgElement) {
    const file = event.target.files[0];
    if (file) {
        const reader = new FileReader();
        reader.onload = function(e) {
            imgElement.src = e.target.result;
            imgElement.style.display = 'block';
        }
        reader.readAsDataURL(file);
    }
}

imageUpload1.addEventListener('change', (event) => handleImageUpload(event, image1));
imageUpload2.addEventListener('change', (event) => handleImageUpload(event, image2));

startButton.addEventListener('click', async () => {
    if (!image1.src || image1.src.endsWith('#') || !image2.src || image2.src.endsWith('#')) {
        resultText.textContent = '두 개의 이미지를 모두 업로드해주세요.';
        return;
    }

    loadingMessage.style.display = 'block';
    resultText.textContent = '';

    try {
        const detections1 = await faceapi.detectSingleFace(image1, new faceapi.TinyFaceDetectorOptions()).withFaceLandmarks().withFaceDescriptor();
        const detections2 = await faceapi.detectSingleFace(image2, new faceapi.TinyFaceDetectorOptions()).withFaceLandmarks().withFaceDescriptor();

        if (!detections1 || !detections2) {
            resultText.textContent = '두 이미지 모두에서 얼굴을 찾을 수 없습니다. 다른 사진을 시도해보세요.';
            loadingMessage.style.display = 'none';
            return;
        }

        // Calculate similarity using Euclidean Distance
        const distance = faceapi.euclideanDistance(detections1.descriptor, detections2.descriptor);
        const similarity = Math.max(0, (1 - distance) * 100).toFixed(2);

        resultText.textContent = `두 얼굴의 궁합 점수는 ${similarity}% 입니다!`;

    } catch (error) {
        console.error(error);
        resultText.textContent = '오류가 발생했습니다. 다시 시도해주세요.';
    } finally {
        loadingMessage.style.display = 'none';
    }
});

// Disable button until models are loaded
startButton.disabled = true;
startButton.textContent = '모델 로딩 중...';
