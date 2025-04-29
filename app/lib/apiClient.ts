import axios from "axios";

const apiClient = axios.create({
    baseURL: process.env.API_BASE_URL,
});

apiClient.interceptors.response.use(
    (response) => response,
    (error) => {
        if (error.response && error.response.status === 422) {
            const errors = error.response.data.detail;
            console.error("Erreur de validation API :", errors);
        }
        return Promise.reject(error);
    }
);

export default apiClient;
